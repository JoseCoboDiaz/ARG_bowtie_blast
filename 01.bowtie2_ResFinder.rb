
#`vsearch --derep_fulllength ResFinder.fasta --output derep_ResFinder`
#`bowtie2-build -f derep_ResFinder.fasta derep_ResFinder`

`mkdir reads_assembled`
aa=File.open("list.txt").each_line do |line|
line.chomp!
puts "......runinng bowtie2 on sample #{line} ..."
`bowtie2 -p 10 --no-unal --very-sensitive-local -x derep_ResFinder -1 reads/"#{line}"_R1.fastq.gz -2 reads/"#{line}"_R2.fastq.gz -S reads_assembled/"#{line}"_ResFinder.sam --al-conc reads_assembled_sensitive/"#{line}"_pairs`
puts "......bowtie2 on sample #{line} finished !!!"
puts "...... sam file transformed to bam file for sample #{line}"
`samtools view -S -b reads_assembled_sensitive/"#{line}"_ResFinder.sam > reads_assembled/"#{line}"_ResFinder.bam`
`rm reads_assembled/"#{line}"_ResFinder.sam`
end
aa.close

puts "ALL ANALYSIS FINISHED !!!"
