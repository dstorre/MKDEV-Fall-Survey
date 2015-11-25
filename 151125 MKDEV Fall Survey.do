	/*
o	File Name: 
o	Author:
o	Date drafted: 
o	Date revised: 
o	Datasets pulled in: 
o	Datasets produced: 
o	Purpose (a broad overview of what the code does):

	1) 
	
	NOTE: 
	NOTE: 
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
	global 	olddata 	"/Volumes/Programs/XXX"								// where you pull the clean data from (mac)
	global newdata 	"/Volumes/Programs/XXX"									// where you store the clean data from (mac)
	global 	output 		"/Volumes/Programs/XXX"								// where you output results to (mac)
	global 	logs		"\\128.18.33.163\Programs\XXX"						// where you save log files, etc.
			}
	
	global version		""													// use v2 if update this file after posting results
	
	log using "${logs}XXX.smcl", replace
