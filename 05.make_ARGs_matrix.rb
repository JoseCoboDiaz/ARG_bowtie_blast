
sample=[]
gene=[]
hsample={}
hgene={}
group=[]
hgroup={}

hgen_fam={}
hgen_group={}
hgen_gen={}
fam=[]
hfam={}

hgen2_group={}
hgen2_fam={}

aa=File.open("phenotypes.txt").each_line do |line|
line.chomp!
#ant(2'')-Ia_1_X04555	Aminoglycoside	
hgen_group[line.split("\t")[0]]=line.split("\t")[2]
hgen_fam[line.split("\t")[0]]=line.split("\t")[3]
hgen_gen[line.split("\t")[0]]=line.split("\t")[1]
hgen2_group[line.split("\t")[1]]=line.split("\t")[2]
hgen2_fam[line.split("\t")[1]]=line.split("\t")[3]
end
aa.close

#######

bb=File.open("blastn_AR_firsthit.txt").each_line do |line|
line.chomp!
#AMBIENTE_0H_link_NB501531:95:HCHTWBGXB:1:11101:1317:6457/2	tet(L)_8_AY081910	98.675	151	2	0	1	151	117	977	4.16e-73	268	tet(L)_8_AY081910
sample << line.split("\_link")[0]
gene << hgen_gen[line.split("\t")[1]]
fam << hgen_fam[line.split("\t")[1]]
group << hgen_group[line.split("\t")[1]]
end
bb.close

#########

gene=gene.uniq
sample=sample.uniq
group=group.uniq
fam=fam.uniq

puts sample

sample.each_index{|a| hsample[sample[a]] = a}		#assign each Genus with the "list" array position
gene.each_index{|a| hgene[gene[a]] = a}
group.each_index{|a| hgroup[group[a]] = a}
fam.each_index{|a| hfam[fam[a]] = a}

matrix = Array.new(gene.length()) {|index| Array.new(sample.length()) {|x| 0}}
gmatrix = Array.new(group.length()) {|index| Array.new(sample.length()) {|x| 0}}
fammatrix = Array.new(fam.length()) {|index| Array.new(sample.length()) {|x| 0}}

### COUNT PROTEIN-FAMILIES PER GENOME AND WRITE ON MATRIX ###

n=0
cc = File.open("blastn_AR_firsthit.txt").each_line do |line|
line.chomp!
	matrix[hgene[hgen_gen[line.split("\t")[1]]]][hsample[line.split("\_link")[0]]]+=1
	fammatrix[hfam[hgen_fam[line.split("\t")[1]]]][hsample[line.split("\_link")[0]]]+=1
	gmatrix[hgroup[hgen_group[line.split("\t")[1]]]][hsample[line.split("\_link")[0]]]+=1
if hgen_fam[line.split("\t")[1]]==nil
puts line
n+=1
end

end
cc.close

puts n
### TO CREATE AND WRITE THE OUTPUT ###
=begin
out=File.new("matrix_ResFinder_genes.txt", 'w')
mm=-1
sample.each {|i| out.print "\t#{i}"}
out.print "\n"
matrix.each {|i|  mm+=1
	out.print "#{gene[mm]}
	i.each {|value| out.print "\t#{value}"
	out.print "\n"}


out2=File.new("matrix_ResFinder_group_genes.txt", 'w')
mm=-1
sample.each {|i| out2.print "\t#{i}"}
out2.print "\n"
gmatrix.each {|i|  mm+=1
	out2.print "#{group[mm]}"
	i.each {|value| out2.print "\t#{value}"}
	out2.print "\n"}


out3=File.new("matrix_ResFinder_antibiotics.txt", 'w')
mm=-1
sample.each {|i| out3.print "\t#{i}"}
out3.print "\n"
fammatrix.each {|i|  mm+=1
	out3.print "#{fam[mm]}"
	i.each {|value| out3.print "\t#{value}"}
	out3.print "\n"}}
=end

out4=File.new("matrix_complete.txt", 'w')
mm=-1
out.print "gene\tgene_group\tantibiotic_family"
sample.each {|i| out4.print "\t#{i}"}
out4.print "\n"
matrix.each {|i|  mm+=1
	out4.print "#{gene[mm]}\t#{hgen2_group[gene[mm]]}\t#{hgen2_fam[gene[mm]]}"
	i.each {|value| out4.print "\t#{value}"}
	out4.print "\n"}

