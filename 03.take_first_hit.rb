
#blastn -query seqs_concatenated.fasta -db ResFinder -out blastn_AR_reads.txt -outfmt '6 std stitle' -max_target_seqs 100 -perc_identity 90 -num_threads 10

name=''

aa=File.open(ARGV[0]).each_line do |line|
line.chomp!
	if line.split("\t")[0]!=name
	puts line
	name=line.split("\t")[0]
	end
end
aa.close
