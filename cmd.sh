#!/bin/sh
#BATCH --job-name="NCI0276"
#BATCH --time=10-00:00:00"
NOW=$(date +"%H%M%S_%m%d%Y")
module load python/3.4.3

export NGS_PIPELINE="/data/khanlab/projects/patidar/Snakemake"

WORK_DIR=/data/khanlab/projects/patidar/Testing/
SNAKEFILE=$NGS_PIPELINE/ngs_pipeline.rules
SAM_CONFIG=$NGS_PIPELINE/config_NCI0231.json
cd $WORK_DIR
snakemake\
	--directory $WORK_DIR \
	--snakefile $SNAKEFILE \
	--configfile $SAM_CONFIG \
	--jobname '{rulename}.{jobid}' \
	--nolock -k -p -T -j 3000 \
	--stats ngs_pipeline_${NOW}.stats \
	--cluster "sbatch -o log/{params.rulename}.%j.o {params.batch}" >& ngs_pipeline_${NOW}.log

# Summary 
#snakemake --directory $WORK_DIR --snakefile $SNAKEFILE --configfile $SAM_CONFIG --summary

## DRY Run with Print out the shell commands that will be executed
#snakemake --directory $WORK_DIR --snakefile $SNAKEFILE --configfile $SAM_CONFIG --dryrun -p

#For saving this to a file
#snakemake --directory $WORK_DIR --snakefile $SNAKEFILE --configfile $SAM_CONFIG --dag | dot -Tpng > dag.png
#snakemake --directory $WORK_DIR --snakefile $SNAKEFILE --configfile $SAM_CONFIG -n --forceall --rulegraph | dot -Tpng > rulegraph.png
#echo DAG |mutt -s "DAG" -a dag.pdf -- patidarr@mail.nih.gov
