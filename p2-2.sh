#!/bin/bash
fName=
lName=
file=
wordCount=

error=

usage() {
	echo "Usage:"
	echo "-f: Specify a file name"
	echo "-n: Specify a first name"
	echo "-l: Specify a last name"
	echo -e "-h: Display this page\n"
	echo -e "The flags '-f' '-n' and '-l' are all required and will output a file called"
	echo "'output.json' with the contents of:"
	echo -e "\t<<your_first_name>> <<your_last_name>>"
	echo -e "\t<<date>>"
	echo -e "\tThe word count of the file is <<number of words>>"
}

verifyParams(){
	fileFlag=1
	nameFlag=1
	lnameFlag=1
	for item in ${@} #loop through everything that was passed in while calling the script
	do
		new_item=$( echo @${item} | egrep "^@-" | sed 's/^@//') #just grabs any item passed in with a '-'
		if [ ! -z "$new_item" ] #if the new_item variable is empty, then don't do anything
		then
			case ${new_item} in
				-f) fileFlag="0";;
				-n) nameFlag="0";;
				-l) lnameFlag="0";;
				-f) ;; #don't do anything if they exist, this is checked down below
				' ') ;; #we don't care if spaces are present
				*) echo -e "${new_item} is not a valid argument\n\n" ;;
			esac
		fi
	done

	if [ ${fileFlag} -eq "1" ]
	then
		error+="You must specify the '-f' flag\n"
	fi
	if [ ${nameFlag} -eq "1" ]
	then
		error+="You must specify the '-n' flag\n"
	fi
	if [ ${lnameFlag} -eq "1" ]
	then
		error+="You must specify the '-l' flag\n"
	fi

	if [ ! -z "${error}" ]
	then
		echo -e ${error}
		usage
		exit 1
	fi

	while getopts "f:l:n:h" OPTION; #require arguments after the 'f', 'l', and 'n' flags
	do
	  case "${OPTION}" in
	    f) file=${OPTARG} ;;
	    n) fName=${OPTARG} ;;
	    l) lName=${OPTARG} ;;
	    h) usage ;;
	    *) usage ;;
	  esac
	done
}

countWords() {
	wordCount=$( cat ${1} | wc -w)
}

main() {
	verifyParams ${@}

	countWords ${file}
	echo "" > "output.json" #clear the file just in case
	echo ${fName} ${lName} >> "output.json"
	echo $(date) >> "output.json" 
	echo "The word count of the file is ${wordCount}" >> "output.json"

}

main ${@}
