takes_ary_as_arg()
{
    declare -a ary=("${!1}")
    echo "${ary[@]}"
}

var=("1" "2")
    
takes_ary_as_arg var[@] 


# TODO: Searches cwd only
# TODO: Only handles html files
# TODO: Doesn't recurse into subfolders


# $1 is file or folder to create new, rotproof versions of. 
# Outputs are copies in same directory, "-rotproof".
rotgone () {
	#if [[ -z $1 ]]
	#    then return "Enter path as 1st arg pls"
	#else
	#    input=$1
    #fi
	input=$(pwd)

	if [[ -d $input ]]
	    then for file in $input/*.html
	    	do mothballFile file
	    	echo "."
	    done
	elif [[ -f $input ]]
	    do mothballFile $input
	else
		echo "That's not a file nor a dir"
		exit 1
    fi
	
	return "Rotproofing complete."
}


mothballFile () {
	links=scanForRot $1 $2
	#candidates=excludeArchived $links[@]
	archived=archiveRot $links[@]
	output=rewriteRot $archived[@] $1
}


# All links: 's/.*href="\([^"]*\).*/\1/p'
# All non IA links: 's/.*href="\([^"]*\).*/\1/p'
scanForRot () {
	if [[ -z $2 ]]
		regex='s/.*href="\([^"]*\).*/\1/p'
	else
		regex='s/.*href="\([^"]*\).*/\1/p'
	fi

	links=$(sed -n $regex $1)
	return $links
}


excludeArchived () {
	for link in $1
	do cat "$fn"
	done
	return $candidates
}


archiveRot () {
	$archived=()
	for link in $1
		do curlHandle $link $archived
	done
	return $archived
}


# $1 is link to save, $2 is arr
curlHandle () {
	res=curl https://web.archive.org/save/$1
	
	if $res
		echo "Couldn't save "$1
	else 
		$2[]
	fi
}


rewriteRot () {
	outFile=cp $2 . "-rotproof"
	
	return sed -i -e 's/abc/XYZ/g' outFile
}


rotgoneFolder () {
	if [[ -z $1 ]]
	        then dir='$PWD'
	else
	        dir=$1
	    fi
	links=scanForRot dir
	candidates=excludeArchived links
	archived=archiveRot
	output=rewriteRot
	return $output
}
