# I downloaded the EE and L3 predictions generated by modEnocde for Ce10 EE and L3. Their model was bult cross-species using a subset of chromosomes, and only L3.
# I'll take each of their predicted states and compare them using a jaccard index to all of my individual states as well as my combined states.

hiHMModel=$1
chromHMModelSplitPredFileList=$2
outDir=$3
mkdir -p $outDir

cut -f 4 $hiHMModel | sort -u > compare_hiHMMToMyChromHMM.tmp

while read hiState
do
    echo "Starting on ${hiState}"
    outFile="${outDir}/${hiState}_summary.txt"
    while read line
    do
        echo ${line}
        echo $(basename ${line}) >> ${outFile}
        grep $hiState $hiHMModel | \
        perl -lane 'print join("\t", ("chr".$F[0], $F[1], $F[2], $F[3]));' | \
        bedtools jaccard -a - -b $line >> ${outFile}
        echo "" >> ${outFile}
    done < ${chromHMModelSplitPredFileList}
done < compare_hiHMMToMyChromHMM.tmp

rm compare_hiHMMToMyChromHMM.tmp