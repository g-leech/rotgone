
# $1 is file or folder to create new, rotproof versions of. 
# $2 is output folder
# $3 is pattern to search. Defaults to extracting from <a hrefs
rotgone () {
	if [[ -z $1 ]];	then 
		echo "Exiting: enter path of file as 1st arg. ('.' will do.)"
		return 0
	else
		input=$1
	fi

	if [[ $2 ]]; then
		output=$2
	else
		output="rotproofLinks"
		mkdir -p $output	
	fi
	
	myDate=$(date "+%Y%m%d")
	failFile="$output/links_not_saved-$myDate.txt"
	> $failFile
		

	if [[ -d $input ]]; then 
		htmls=$(find $input -type f -name "*.html" -print)
		for file in $htmls ; do 
			printf "\n\nLooking in $file:"; 
			mothballLinks $file $output $failFile
		done

	elif [[ -f $input ]]; then 
		echo "-> Sending links in $input to InternetArchive ->"
		mothballLinks $input $output $failFile

	else
		echo "Exiting: Wow, that's neither a file nor a directory."
	fi

	warn_unsaved $failFile
	rm $failFile
	printf "\n\n-> Rotproofing complete: archive links saved in ./$output/...-rotproof.txt.\n\n"
}


# $1 is file to find links in
# $2 is output folder
# $3 is file to record errors in
# $4 is pattern to match: all links, or only non-webarchive
mothballLinks () {
	tmp="links.txt"
	touch $tmp
	path=$(echo $1 | tr "/" "-")
	outFile="$2/${path%.*}-rotproof.txt"
	touch $outFile
	failFile="$3"

	scanForRot "$1" "$failFile" "$tmp"

	cnt=$(cat $tmp | wc -l)
	if [[ $cnt == 0 ]]; then
		rm $outFile
	else
		sendToWebArchive "$tmp" "$outFile" "failFile"
	fi
	rm $tmp
}


# $1 : file to find links in
# $2 : file to record errors in
# $3 : temporary output file for links
# $4 : pattern
# All links: 's/.*href="\([^"]*\).*/\1/p'
# All non IA links: 's/.*href="\([^http://web.archive.org][^"]*\).*/\1/p'
scanForRot () {
	failFile="$2"
	tmpFile="$3"
	regex=$(handlePattern $4)
	links=$(sed -n $regex $1 )

	if [[ -z $links ]]; then
		echo "- No links found in "$1 >> "$failFile"
	else
		echo $links | tr " " "\n" > $tmpFile
	fi
}


handlePattern () {
	if [[ -z $1 ]]; then
		echo 's/.*href="\([^"]*\).*/\1/p'
	else
		echo $1
	fi
}


# $1 is file with links to archive
# $2 is output file
# $3 is fail file
# NB: tr fails horribly in-memory here, as does 
# 	echo $1 | awk -v RS=' +' -v ORS="\n"  '1' | sed '$d'
# Hence tmp file $1. Boo.
sendToWebArchive () {
	outFile="$2"
	cat $1 |
	{
		while read link; do
			echo "-- Archiving $link" 
			location=$(curlHandle $link $3) ;
			if [[ $location ]]; then 
				echo "http://web.archive.org$location" >> "$outFile"
			fi
		done
	}
}


# $1 is link to save
curlHandle () {
	failFile="$3"
	toSave="web.archive.org/save/$1"
	location=$(curl -s --head "$toSave" | grep "Content-Location"  | cut -c 19-)

	if [[ -z $location ]]; then
		echo $1 >> "$failFile"
		return 0
	else 
		echo $location
	fi
}


# $1 is the failFile from above
warn_unsaved () {
	unsaved=$(cat "$1" | wc -l)
	
	if [[ $unsaved != 0 ]]; then
		echo "The following files could not be saved: "
		cat $1
	fi
}


# excludeArchived () {
# 	for link in $1
# 		do cat "$link"
# 	done
# 	#echo $candidates
# }

#rewriteRot () {
#	outFile=cp $2 . "-rotproof"
#	
#	return sed -i -e 's/abc/XYZ/g' outFile
#}



