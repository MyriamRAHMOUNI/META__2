gunzip EchE_R1.fastq.gz
gunzip EchE_R2.fastq.gz

#Identifier et quantifier les bactéries présentes
	#aligner nos reads avec all_genome.fasta 
./soft/bowtie2 --end-to-end --fast -x ./databases/all_genome.fasta -1 EchE_R1.fastq -2 EchE_R2.fastq -S EchE.sam
	#Analyser le fichier .sam : quantifier l'abandance de chaque bactérie
