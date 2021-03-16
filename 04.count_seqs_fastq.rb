#`echo $(zcat "#{line}".fastq.gz | grep -c '@') > "#{line}".txt`

`ls ../trimmed/ > list_count.txt`


out=File.new("counts_raw_reads.txt","w")
out.puts "File\tnumber_seqs"

aa=File.open("list_count.txt").each_line do |line|
line.chomp!
	if line =~ /_R1/
	count=''
	count<<`echo $(zcat ../trimmed/#{line}| grep -c '@')`
	out.puts "#{line}\t#{count}"
	puts "#{line}\t#{count}"
	end 
end
aa.close


`ls Avelino_ProcessingPlant_Plate2/ > list_count2.txt`
count=''

bb=File.open("list_count2.txt").each_line do |line|
line.chomp!
	if line =~ /_R1/
	count=''
	count<<`echo $(zcat Avelino_ProcessingPlant_Plate2/#{line}| grep -c '@')`
	out.puts "#{line}\t#{count}"
	puts "#{line}\t#{count}"
	end
end
bb.close

`rm list_count*`

