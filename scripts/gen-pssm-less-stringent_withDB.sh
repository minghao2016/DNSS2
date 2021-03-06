#!/bin/bash
###############################################################################
# Name %n  : gen-pssm-less-stringent.sh
# Desc %d  : Generate and save a PSSM for a query using psi blast and 
#  very lax evalues, for those harder targets
# Input %i : A fasta file and two output file names, database path
# Output %o: The pssm and a report 
#
# Author: Jie Hou
# URL: http://merit.oryo.us
# Date: Wed Jan 25 2012
# Latest Modified Date: 11/02/2016 by Jie Hou
###############################################################################
GLOBAL_PATH='/faculty/jhou4/tools/DNSS2/';

if [[ $# -ne 4 ]]; then
  echo "Usage: $0 <seq.fasta> <out_fname1(pssm)> <out_fname2(report)>";
  exit;
fi

FASTA=$1
PSSM=$2
REPORT=$3
BLAST_NR_DB=$4

#DB="nr90"

# Get paths using PATHFINDER
BLAST_PATH="$GLOBAL_PATH/programs/ncbi-blast-2.2.25+/bin"; #`$PATHFINDER/get-path.sh NCBI_BLAST`/bin";
#BLAST_NR_DB="$GLOBAL_PATH/nr_database"; #`$PATHFINDER/get-path.sh BLAST_DB`";
BLASTMAT="$GLOBAL_PATH/programs/ncbi-blast-2.2.25+/matrices"; #`$PATHFINDER/get-path.sh BLAST_MAT`";

echo "Running PSI-Blast with $DB...";
$BLAST_PATH/psiblast -query "$FASTA" -evalue 10 -inclusion_ethresh 10 -db "$BLAST_NR_DB" -num_iterations 3 -outfmt "0"\
  -out $REPORT -num_alignments 2000 -out_ascii_pssm $PSSM


### or try psedo
if [ -f "$PSSM" ]
then
	echo "$PSSM found."
  exit
else
	echo "Try psedp."
  $BLAST_PATH/makeblastdb -in $FASTA
	$BLAST_PATH/psiblast -query "$FASTA" -db "$FASTA" -num_iterations 3 -outfmt "0"\
  -out $REPORT  -out_ascii_pssm $PSSM
fi
