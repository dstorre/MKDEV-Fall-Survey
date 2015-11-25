	/*
	File Name: 151125 MKDEV Fall Survey
	Author: Daniela Torre
	Date drafted: Nov 25
	Date revised: 
	Datasets pulled in: 
	
	1. 151125_MK_fall survey all schools.csv

	Datasets produced: 
	Purpose (a broad overview of what the code does):

	1) Import csv file, save as dta
	2) Do basic descriptives
		- Tab means 
		- Tab means by school
		- Tab means by grade
	2) Do basic descriptives-> matrix notation
		- Tab means by school
		- Tab means by grade
	
	
	
	*/

	clear all 
	version 14
	capture log close
	set more off
	
	***********************************************************************************************************************************************************
		// 0. Change directories and set up a name to add to any output so it can be traced back to this file
	***********************************************************************************************************************************************************
	local pc = 0 // make switch to go back and forth b/w pc and mac. 
	
	
	if `pc' ==1 {
	/* PC */
	global 	olddata 	"\\128.18.33.163\Programs\XXXX"						// where you pull the clean data from
	global 	newdata 	"\\128.18.33.163\Programs\XXXX"						// where you store the clean data 
	global 	output 		"\\128.18.33.163\Programs\XXXX"						// where you output results to
	global 	logs		"\\128.18.33.163\Programs\XXXX"						// where you save log files, etc.
	}	
	
	else {
	/* MAC */
	global 	olddata 	"~/Documents/Projects/McKnight MK/QA MK/Data/Original Data/"			// where you pull the clean data from (mac)
	global 	newdata 	"~/Documents/Projects/McKnight MK/QA MK/Data/Clean Data/"				// where you store the clean data from (mac)
	global 	output 		"~/Documents/Projects/McKnight MK/QA MK/Output/Unformatted/"			// where you output results to (mac)
	global 	logs		"~/Documents/Projects/McKnight MK/QA MK/Logs and Documentation/"		// where you save log files, etc.
			}
	
	global version		""													// use v2 if update this file after posting results
	
	log using "${logs}MKDEV Fall Survey.txt", replace
	
	***********************************************************************************************************************************************************
		// 1. Import csv file, save as dta
	***********************************************************************************************************************************************************
	insheet using "${olddata}151125_MK_fall survey all schools.csv", comma names clear
	
	replace grade="Coach" if grade=="c"		// Fix up grade variable
	replace grade="k" if grade=="k (DLL)"
	
	gen grade_n=.
	replace grade_n=-1 	if grade=="pk"		// Make numeric grade variable 
	replace grade_n=0 	if grade=="k"
	replace grade_n=1 	if grade=="1"
	replace grade_n=2 	if grade=="2"
	replace grade_n=3 	if grade=="3"
	replace grade_n=9 	if grade=="Coach"

	gen district=""							//Make district variable
	replace district="CPA" if school=="CPA"
	replace district="MPS" if school=="Andersen" || school=="Jefferson"
	replace district="SPPS" if school=="SPMA" || school=="Wellstone"
	replace district="BCPS" if school=="Earle Brown"
	
	drop date v20							//Drop superfluous vars

	save "${newdata}2015_MK_fall survey all schools.dta", replace	//Save data
	
	
	
	***********************************************************************************************************************************************************
		// 2. Do basis descriptives esttab
	***********************************************************************************************************************************************************
	
	
	// Tab just means 
	
	#delimit ;
	eststo descriptives:	
		estpost tabstat decoding-sped ,
		statistics(mean n) /* Can add any stats here */
		columns(statistics) /*Each stat gets its own column */
	;
	
	esttab descriptives using  "${output}2015_MK_fall survey_basic descriptives.csv",
        main(mean 2) /* Use mean as main report */ 
        unstack /* Want them in one column */
		nogaps /*take out empty rows*/
        nonote /*No note */
        label /*Use value labels */
        replace /*Replace if it exists */  
        title("Descriptive Statistics for Variables in Analysis")
	;
	
	// Tab  means by school 
	
	#delimit ;
	eststo descriptives:
		estpost tabstat decoding-sped, by(school) 
		statistics(mean n) /* Can add any stats here */
		columns(statistics) /*Each stat gets its own column */
	;
	
	esttab descriptives using  "${output}2015_MK_fall survey_basic descriptives by school.csv",
        main(mean 2) /* Use mean as main report */ 
        unstack /* Want them in one column */
		nogaps /*take out empty rows*/
        nonote /*No note */
        label /*Use value labels */
        replace /*Replace if it exists */  
        title("Descriptive Statistics for Variables in Analysis")
	;
	
	// Tab  means by grade 
	
	#delimit ;
	eststo descriptives:
		estpost tabstat decoding-sped , by(grade)
		statistics(mean n) /* Can add any stats here */
		columns(statistics) /*Each stat gets its own column */
	;
	
	esttab descriptives using  "${output}2015_MK_fall survey_basic descriptives by grade.csv",
        main(mean 2) /* Use mean as main report */ 
        unstack /* Want them in one column */
		nogaps /*take out empty rows*/
        nonote /*No note */
        label /*Use value labels */
        replace /*Replace if it exists */  
        title("Descriptive Statistics for Variables in Analysis")
	;

	# delimit cr

	***********************************************************************************************************************************************************
		// 3. Do basic descriptives matrix
	***********************************************************************************************************************************************************
	
	// Tab by Grade
	

	matrix mean_grade= J(16,7,.)					//Create empty matrix
	
	# delimit ;
	matrix rownames mean_grade= 					//Name matrix rows
	"Teaching decoding"
	"Teaching spelling"
	"Teaching concepts of print"
	"Teaching comp strategies"		
	"Keeping a running record"
	"Using STEP data to plan GR"
	"Using STEP data to plan WG"
	"Developing independent work"
	"Using comp conversation prompts"
	"Managing a classroom"
	"Selecting appropriate texts"
	"Using formative assessments"
	"Reading development stages"
	"Supporting EL"
	"Supporting SPED"
	"Obs"
	
	;
	matrix colnames mean_grade=					//Name matrix cols
	"Overall"
 	"PK"
	"Kingergarten"
	"1st Grade"
	"2nd Grade"
	"3rd Grade"
	"Coach"
	;
	
	#delimit cr	
	
	
	local c=2							
	local r=1
	foreach var of varlist decoding-sped {		//loop through vars of interest
		
		qui sum `var'							//sum each var
		matrix mean_grade[`r',1]= r(mean)		//put grand mean in matrix
		matrix mean_grade[16,1]= r(N)			//put N in matrix

		levelsof grade_n, local(grade) 			
		foreach l of local grade {				//loop through grades
			   qui sum `var' if grade_n==`l' 	//sum each var by grade
			   matrix mean_grade[`r',`c']= r(mean)	//Put means in cells
			   matrix mean_grade[16,`c']= r(N)		//Put obs in cells
			   local c=`c'+1
			   }								//Close grade loop

			  local r=`r'+1						//Move to next row
			  local c=2							//Go baack to col 2
			  }									//Close variable loop
			   

	putexcel A1=matrix(mean_grade, names) (A1:H18)=nformat("number_d2") (A17:H17)=nformat("number")  ///
	using "${output}2015_MK_fall survey_basic descriptives1.csv", modify sheet("by_grade", replace) //Save table to excel

	
	//Tab by District
	matrix mean_dis= J(16,5,.)					//Create empty matrix
	
	
	# delimit ;
	matrix rownames mean_dis= 					//Name rows
	"Teaching decoding"
	"Teaching spelling"
	"Teaching concepts of print"
	"Teaching comp strategies"		
	"Keeping a running record"
	"Using STEP data to plan GR"
	"Using STEP data to plan WG"
	"Developing independent work"
	"Using comp conversation prompts"
	"Managing a classroom"
	"Selecting appropriate texts"
	"Using formative assessments"
	"Reading development stages"
	"Supporting EL"
	"Supporting SPED"
	"Obs"
	
	;
	matrix colnames mean_dis=					//Name Columns
	"Overall"
 	"BCPS"
	"CPA"
	"MPS"
	"SPPS"
	;
	
	#delimit cr	
	
	
	local c=2	
	local r=1
	foreach var of varlist decoding-sped {
		
		qui sum `var'
		matrix mean_dis[`r',1]= r(mean)
		matrix mean_dis[16,1]= r(N)

		levelsof district, local(district) 
		foreach l of local district {
			   qui sum `var' if district=="`l'"
			   matrix mean_dis[`r',`c']= r(mean)
			   matrix mean_dis[16,`c']= r(N)
			   local c=`c'+1
			   }

			  local r=`r'+1
			  local c=2
			  }
			   

	putexcel A1=matrix(mean_dis, names) (A1:H18)=nformat("number_d2") (A17:H17)=nformat("number")  ///
	using "${output}2015_MK_fall survey_basic descriptives1.csv", modify sheet("by_dis", replace) 

	log close
	exit
