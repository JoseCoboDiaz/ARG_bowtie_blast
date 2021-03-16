# ARG_bowtie_blast

This is a pipeline to screen antimicrobial resistance genes (ARGs) by a 2 step approach: fastq alignment to ResFinder database (https://bitbucket.org/genomicepidemiology/resfinder_db/downloads/) by bowtie2 (http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml), plus an additional BLAST (http://www.metagenomics.wiki/tools/blast/installhttp://www.metagenomics.wiki/tools/blast/install) against the same database. 

The vsearch (https://github.com/torognes/vsearch) will be employed for dereplicated ResFinder database.

	vsearch --derep_fulllength resfinder_db/ResFinder.fna --output derep_ResFinder.fna

	bowtie2-build derep_ResFinder.fna derep_ResFinder

Firs step, we make a bowtie2 alignment with the filtered reads, using the commands

	ruby 01.bowtie2_ResFinder.rb

	ls reads_assembled/*.1.* > list_assembled.txt

Open list_assembled.txt and find and reemplace “.1.trimmed_pairs” to “”, and “reads_assembled/” to “”. To transform fastq files from bowtie (read1 and read2) to concatenated fasta and add the sample name to the sequences names (to facilitate matrix construction later):

	ruby 02.fasq2tfasta.rb >  seqs_concatenated.fasta

To construct blast database from .fasta file:

	makeblastdb -in resfinder_db/ResFinder.fna -dbtype nucl -out ResFinder

To run blastn versus ResFinder database

	blastn -db ResFinder -query seqs_concatenated.fasta -out blastn_AR_reads.txt -outfmt '6 std stitle' -max_target_seqs 50 -num_threads 10 -perc_identity 70

To take only the first hit and avoid bias due to blastn itself (doi.org/10.1093/bioinformatics/bty833):

	ruby 03.take_first_hit.rb > blastn_AR_firsthit.txt

To count fastq reads for calculate ARGs copies per million reads:

	ruby 04.count_seqs_fastq.rb

Open seqs_count and change “folder/” to “”, and “nameaftersamplename” to “” in order to have a 2 columns: samples name and samples reads count.

To convert blastn output into a final matrix with gene (together to gene group and antibiotic family information) per sample, you need to have the phenotypes.txt file, created according to Mencía-Ares et al. 2020 (https://doi.org/10.1186/s40168-020-00941-7) to run this script:

	ruby 05.make_ARGs_matrix.rb
