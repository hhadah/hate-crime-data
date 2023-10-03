/*
This is a Do File to merge
the crime data with the Law 
Enforcement Agency Identifiers 
Crosswalk. The crosswalk allows
us to merge the crime data with
other datasets. The county leve
crime data uses the FBI's numbering.

Author: Hussain Hadah
First version: July 15, 2021
*/

clear
cls

capture cd ~/
/*
Set global variables for directories
*/

global Crosswalk "~/Dropbox/Research/My Research Data and Ideas/Idea_Crime/Data/Raw/CrossWalk/DS0001/35158-0001-Data.dta"
global WD "~/Dropbox/Research/My Research Data and Ideas/Idea_Crime/Data/DataSets"

/*
set working direcotry
*/

cd "$WD"

/*
Delete duplicates from crosswalk
*/
use "$Crosswalk"

drop if ORI7 == "-1"

save "$Crosswalk", replace

clear
cls
/*
Open Crime data
*/

use "$WD/CrimeData.dta"

/*
Change the ORIGINATING AGENCY IDENTIFIER CODE
variable name in the crime data to match the
seven digits ORIGINATING AGENCY IDENTIFIER CODE
from the crosswalk
*/
rename ORI ORI7

/*
Merge crime data with crosswalk
using the variable ORI7
*/

merge m:1 ORI7 using "$Crosswalk"
keep if _merge == 3
drop _merge

save "CrimeDataWithCrossWalk.dta", replace
