/*Team Member: Zhongce Ji, Jiamin Di, Zhengbang Pan, Minjun Li, Yuhan Duan*/
/* Please use the data we provide, because we have changes some value of variable to the numbers*/

ods html close;
ods listing gpath="C:\Users\Tim.Ji\Desktop\525_Project\reg";


PROC IMPORT OUT= WORK.CAR
            /* Change the directory of the data in your personal computer*/
            DATAFILE= "C:\Users\Tim.Ji\Desktop\525_Project\data\car.xls"
            DBMS=EXCEL REPLACE;
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;


/*Here we consider the liter as catagory variable and apply the dummy data to the liter*/

DATA car;
	set car;
	select;
		when (Liter > 1.0 and Liter <= 2.0) Liter = 0;
		when (Liter > 2.0 and Liter <= 3.0) Liter = 1;
		when (Liter > 3.0 and Liter <= 4.0) Liter = 2;
		when (Liter > 4.0 and Liter <= 5.0) Liter = 3;
		when (Liter > 5.0 and Liter <= 6.0) Liter = 4;
		otherwise Liter = .;
	end;
run;

/* This is for the linear regression for quantitive varibales*/
proc sgscatter data=car;
 matrix Price Mileage / diagonal = (histogram normal kernel);
run;

proc sgscatter data=car;
plot Price*Mileage / reg=(degree=1 clm ) ;
run;


/* Liter */
proc sgscatter data=car;
 matrix Price Mileage / group=Liter  diagonal = (histogram normal kernel);
run;

/* Cylinder */
proc sgscatter data=car;
 matrix Price Mileage / group=Cylinder  diagonal = (histogram normal kernel);
run;

/* Make */
proc sgscatter data=car;
 matrix Price Mileage / group=Make  diagonal = (histogram normal kernel);
run;

/* Type*/
proc sgscatter data=car;
 matrix Price Mileage / group=Type  diagonal = (histogram normal kernel);
run;

/* Doors*/
proc sgscatter data=car;
 matrix Price Mileage / group=Doors  diagonal = (histogram normal kernel);
run;

/* Curise*/
proc sgscatter data=car;
 matrix Price Mileage / group=Curise  diagonal = (histogram normal kernel);
run;

/* Sound*/
proc sgscatter data=car;
 matrix Price Mileage / group=Sound  diagonal = (histogram normal kernel);
run;

/* Leather*/
proc sgscatter data=car;
 matrix Price Mileage / group=Leather  diagonal = (histogram normal kernel);
run;

/* Then we plot the box plot to see whether there is a outliers for mileages and liters*/
proc univariate data=car plots;
var Mileage;
run;

proc univariate data=car plots;
var Price;
run;


proc print data=car;
run;

/*correlation table*/
proc corr data=car;
var Price Mileage;
run;

data newcar;
    set car;
    /* the next line makes a transformed variable */
    Inverse_Price = 1/Price;
	log_price =  log(Price);
run;

proc print data=newcar;
run;


proc reg data=newcar;
model Inverse_Price=Mileage;
plot r.*Mileage r.*p. r.*nqq.;
run;


proc reg data=newcar;
model Price=Mileage;
plot r.*Mileage r.*p. r.*nqq.;
run;

proc reg data=newcar;
model log_price=Mileage;
plot r.*Mileage r.*p. r.*nqq.;
run;


/*multiple linear regression*/
/* create dummy variable for the category variables*/
/*make*/
 data newcar2;
 	set newcar;
	if make = 0 Then Make_Buick = 1;
		else Make_Buick = 0;
	if make = 1 Then Make_Cadillac = 1;
		else Make_Cadillac = 0;
	if make = 2 Then Make_Chevrolet = 1;
		else Make_Chevrolet = 0;
	if make = 3 Then Make_Pontiac = 1;
		else Make_Pontiac = 0;
	if make = 4 Then Make_SAAB = 1;
		else Make_SAAB = 0;
	if make = 5 Then Make_Saturn = 1;
		else Make_Saturn = 0;
		/*type*/
	if Type = 0 Then Type_Sedan = 1;
		else Type_Sedan = 0;
	if Type = 1 Then Type_Convertible = 1;
		else Type_Convertible = 0;
	if Type = 2 Then Type_Hatchback = 1;
		else Type_Hatchback = 0;
	if Type = 3 Then Type_Coupe = 1;
		else Type_Coupe = 0;
	if Type = 4 Then Type_Wagon = 1;
		else Type_Wagon = 0;
		/*Cylinder*/
	if Cylinder = 0 Then Cylinder_4 = 1;
		else Cylinder_4 = 0;
	if Cylinder = 1 Then Cylinder_6 = 1;
		else Cylinder_6 = 0;
	if Cylinder = 2 Then Cylinder_8 = 1;
		else Cylinder_8 = 0;
		/*Liter*/
	if Liter = 0 Then Liter1_2 = 1;
		else Liter1_2 = 0;
	if Liter = 1 Then Liter2_3 = 1;
		else Liter2_3 = 0;
	if Liter = 2 Then Liter3_4 = 1;
		else Liter3_4 = 0;
	if Liter = 3 Then Liter4_5 = 1;
		else Liter4_5 = 0;
	if Liter = 4 Then Liter5_6 = 1;
		else Liter5_6 = 0;
	run;


proc print data=newcar2;
	run;


proc reg data=newcar2;
model Inverse_Price=Mileage Make_Buick Make_Cadillac Make_Chevrolet Make_Pontiac Make_SAAB Make_Saturn Type_Sedan Type_Convertible Type_Hatchback Type_Coupe Type_Wagon Cylinder_4 Cylinder_6 Cylinder_8 Liter1_2 Liter2_3 Liter3_4 Liter4_5 Liter5_6 Doors Cruise Sound Leather/ss1;
plot r.*Mileage r.*p. r.*nqq.;  /* here r=residual, p=predicted (fitted),
                      nqq=normal quantiles (expected values under normality)
                      BE SURE TO HAVE DOTS AFTER r, p, nqq
                      This creates the plot of 1) residuals vs. x, 2) residuals vs. predicted,
                      and 2) normal probability plot of residuals */
run;


proc reg data=newcar2 outset=out;
model Inverse_Price=Mileage Make_Buick Make_Cadillac Make_Chevrolet Make_Pontiac Make_SAAB Make_Saturn Type_Sedan Type_Convertible Type_Hatchback Type_Coupe Type_Wagon Cylinder_4 Cylinder_6 Cylinder_8 Liter1_2 Liter2_3 Liter3_4 Liter4_5 Liter5_6 Doors Cruise Sound Leather/ selection = rsquare adjrsq cp aic sbc best=4;
run;

/* adj R,
0.9138: 17(1), 17(2), 17(3), 17(4),
0.9137: 18(1), 18(2), 18(3), 18(4), 19(1), 19(2), 19(3), 19(4)

C(p),
20: 19(1), 19(2), 19(3), 19(4)
17: 17(1), 17(2), 17(3), 17(4),

AIC,
-19297.720 : 16(1), 16(2), 16(3), 16(4),
-19296.432 : 17(1), 17(2), 17(3), 17(4),

Common: 17(1), 17(2), 17(3), 17(4),

17(1): Mileage Make_Buick Make_Cadillac Make_Chevrolet Make_SAAB Type_Sedan Type_Convertible Type_Wagon Cylinder_4 Cylinder_6 Liter1_2 Liter3_4 Liter5_6 Doors Cruise Sound Leather

17(2): Mileage Make_Buick Make_Cadillac Make_Chevrolet Make_SAAB Type_Sedan Type_Convertible Type_Wagon Cylinder_4 Cylinder_8 Liter1_2 Liter2_3 Liter4_5 Doors Cruise Sound Leather

17(3): Mileage Make_Buick Make_Cadillac Make_Chevrolet Make_SAAB Type_Sedan Type_Convertible Type_Wagon Cylinder_4 Cylinder_8 Liter1_2 Liter2_3 Liter5_6 Doors Cruise Sound Leather

17(4): Mileage Make_Buick Make_Cadillac Make_Chevrolet Make_SAAB Type_Sedan Type_Convertible Type_Wagon Cylinder_4 Cylinder_8 Liter1_2 Liter3_4 Liter4_5 Doors Cruise Sound Leather


/*Best Model 1 : */

proc reg data=newcar2;
model Inverse_Price=Mileage Make_Buick Make_Cadillac Make_Chevrolet Make_SAAB Type_Sedan Type_Convertible Type_Wagon Cylinder_4 Cylinder_6 Liter1_2 Liter3_4 Liter5_6 Doors Cruise Sound Leather/vif;
plot r.*Mileage r.*p. r.*nqq.;  /* here r=residual, p=predicted (fitted),
                      nqq=normal quantiles (expected values under normality)
                      BE SURE TO HAVE DOTS AFTER r, p, nqq
                      This creates the plot of 1) residuals vs. x, 2) residuals vs. predicted,
                      and 2) normal probability plot of residuals */
run;


proc reg data=newcar2;
model Inverse_Price=Mileage Make_Buick Make_Cadillac Make_Chevrolet Make_SAAB Type_Sedan Type_Convertible Type_Wagon Cylinder_4 Cylinder_8 Liter1_2 Liter2_3 Liter4_5 Doors Cruise Sound Leather/vif;
plot r.*Mileage r.*p. r.*nqq.;  /* here r=residual, p=predicted (fitted),
                      nqq=normal quantiles (expected values under normality)
                      BE SURE TO HAVE DOTS AFTER r, p, nqq
                      This creates the plot of 1) residuals vs. x, 2) residuals vs. predicted,
                      and 2) normal probability plot of residuals */
run;


proc reg data=newcar2;
model Inverse_Price=Mileage Make_Buick Make_Cadillac Make_Chevrolet Make_SAAB Type_Sedan Type_Convertible Type_Wagon Cylinder_4 Cylinder_8 Liter1_2 Liter2_3 Liter5_6 Doors Cruise Sound Leather/vif;
plot r.*Mileage r.*p. r.*nqq.;  /* here r=residual, p=predicted (fitted),
                      nqq=normal quantiles (expected values under normality)
                      BE SURE TO HAVE DOTS AFTER r, p, nqq
                      This creates the plot of 1) residuals vs. x, 2) residuals vs. predicted,
                      and 2) normal probability plot of residuals */
run;


proc reg data=newcar2;
model Inverse_Price=Mileage Make_Buick Make_Cadillac Make_Chevrolet Make_SAAB Type_Sedan Type_Convertible Type_Wagon Cylinder_4 Cylinder_8 Liter1_2 Liter3_4 Liter4_5 Doors Cruise Sound Leather/vif;
plot r.*Mileage r.*p. r.*nqq.;  /* here r=residual, p=predicted (fitted),
                      nqq=normal quantiles (expected values under normality)
                      BE SURE TO HAVE DOTS AFTER r, p, nqq
                      This creates the plot of 1) residuals vs. x, 2) residuals vs. predicted,
                      and 2) normal probability plot of residuals */
run;
