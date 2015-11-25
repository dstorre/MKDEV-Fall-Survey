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
	
	save "${newdata}2015_MK_fall survey all schools.dta", replace
	
	drop date v20
	
	
	***********************************************************************************************************************************************************
		// 2. Do basis descriptives
	***********************************************************************************************************************************************************
	
	sum
	
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

	


