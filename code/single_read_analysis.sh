################################################################################
#
# single_read_analysis.sh
#
#
# Here we get the error rates for the individual sequence reads
#
# Dependencies...
# * The *.fasta and *.qual files out of the data/raw/ directory
#
# Produces
# * The error rates for each individual read
# * From each read file, we will need...
#   - *.error.summary
#   - *.error.matrix
#   - *.error.quality
# * These will be used to make box plots showing the relationship between the
#   quality scores and error type, the effect of the position in the read on
#   the error rate, and the substitution matrix
#
################################################################################

FASTA=$1
QUAL=$(echo $FASTA | sed -e s/fasta/qual/)

FINAL_FASTA=$(echo $FASTA | sed -e s/raw/process/)

#need to get path to this folder
OUTPUT_PATH=$(echo $FINAL_FASTA | sed -e s/Mock.*fasta//)
mkdir -p $OUTPUT_PATH

if [[ $FASTA == *"R1"* ]]; then
    mothur "#set.dir(output=$OUTPUT_PATH);
        align.seqs(fasta=$FASTA, reference=data/references/HMP_MOCK.align, processors=12);
        filter.seqs(fasta=current-data/references/HMP_MOCK.align, vertical=T);
        seq.error(fasta=current, qfile=$QUAL, report=current, reference=data/references/HMP_MOCK.filter.fasta);"
else
    mothur "#set.dir(output=$OUTPUT_PATH);
        reverse.seqs(fasta=$FASTA, qfile=$QUAL);
        align.seqs(fasta=current, reference=data/references/HMP_MOCK.align, processors=12);
        filter.seqs(fasta=current-data/references/HMP_MOCK.align, vertical=T);
        seq.error(fasta=current, qfile=current, report=current, reference=data/references/HMP_MOCK.filter.fasta);"
fi

rm $(echo $FINAL_FASTA | sed -e s/fasta/align/)
rm $(echo $FINAL_FASTA | sed -e s/fasta/filter.fasta/)
rm $(echo $FINAL_FASTA | sed -e s/fasta/align.report/)