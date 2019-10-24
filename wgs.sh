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
./soft/blastn -query ./results/genes_full.fna -db ./databases/resfinder.fna -outfmt '6 qseqid sseqid pident qcovs evalue' -out ./results/annotation_blast.out -evalue 0.001 -qcov_hsp_perc 80 -perc_identity 80 -best_hit_score_edge 0.001

#ResFinder is a database that captures antimicrobial resistance genes from whole-genome data sets; qcovs = Query Coverage Per Subject; E-value is the number of expected hits of similar quality (score) that could be found just by chance; pident = percentage of identical matches

# REPONSE QUESTION : 

'''Est ce que vos génomes présentes des gènes de résistance pour certains antibiotiques ? '''

'''''L échantillon E présente 31 gènes de résistance pour certains antibiotiques'''''
