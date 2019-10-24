gunzip EchE_R1.fastq.gz
gunzip EchE_R2.fastq.gz
mkdir results

# Identifier et quantifier les bactéries présentes
	# 1- aligner nos reads avec all_genome.fasta 
./soft/bowtie2 --end-to-end --fast -x ./databases/all_genome.fasta -1 EchE_R1.fastq -2 EchE_R2.fastq -S ./results/EchE.sam
	# 2- Analyser le fichier .sam : quantifier l'abandance de chaque bactérie
samtools view -b ./results/EchE.sam -1 -o ./results/EchE.bam
samtools sort ./results/EchE.bam -o ./results/EchE_sorted.bam
samtools index ./results/EchE_sorted.bam
samtools idxstats ./results/EchE_sorted.bam
samtools idxstats ./results/EchE_sorted.bam > ./results/comptage.txt
grep ">" ./databases/all_genome.fasta|cut -f 2 -d ">" > ./results/association.tsv

# 3-Assembler le génome de bactéries présentes 
./soft/megahit -1 EchE_R1.fastq -2 EchE_R2.fastq --k-max 21 --memory 0.4 -o ./results/megahit_result

# 4-prédire les gènes
./soft/prodigal -i ./results/megahit_result/final.contigs.fa -d ./results/genes.fna

# 5-genes complets
sed "s:>:*\n>:g" ./results/genes.fna | sed -n "/partial=00/,/*/p"|grep -v "*" > ./results/genes_full.fna 


# 6-Annoter les gènes complets
'''     6. Annoter les gènes “complets” contre la banque resfinder (database/resfinder.fna) à l’aide de blastn. Vous sélectionnerez à l’aide de blast, les gènes avec une identité de >=80% et une couverture >= 80% pour une evalue supérieure à 1E-3. 
Est ce que vos génomes présentes des gènes de résistance pour certains antibiotiques ? '''
