
#`bioawk -c fastx '{print ">"$name"\n"$seq}' input.fastq > output.fasta`

`ls reads_assemble/*pairs.1 > list_assembled_sensitive.txt`

n=0
hseq={}
name=''
sample=''

aa=File.open("list_assembled.txt").each_line do |file|
file.chomp!
	if file =~ /^(\S+\_\S+)/
	sample=$1
	end
	bb=File.open("#{ARGV[0]}/#{file}_pairs.1").each_line do |line|
#	bb=File.open("reads_assembled/#{file}.1.trimmed_pairs").each_line do |line|
	line.chomp!
		if line =~ /^@(\S+)/	
			name=$1
			n=1
		elsif n==1
			hseq[name]=line
			n=0
		end
	end
	bb.close

	cc=File.open("#{ARGV[0]}/#{file}_pairs.2").each_line do |line|
	line.chomp!
		if line =~ /^@(\S+)/	
			name=$1
			n=1
#			puts ">#{sample}_link_#{name}" # link is to have a easy point to split sample name from sequence name
			puts ">#{sample}_link_#{name}"
			puts "#{hseq[name]}"
			puts ">#{sample}_link_#{name}"
		elsif n==1
			n=0
#			puts "#{hseq[name]}#{line}"
			puts line
		end
	end
	cc.close
end
aa.close
