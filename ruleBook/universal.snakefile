SUB_IGV = {}
if 'subject' in config:
	for subject in config['subject'].keys():
		SUB_IGV[subject] = ["{subject}/{TIME}/{sample}/{sample}.bwa.final.bam".format(TIME=TIME, subject=SAMPLE_TO_SUBJECT[s], sample=s) for s in config['subject'][subject]]
		SUB_IGV[subject]+= ["{subject}/{TIME}/{sample}/{sample}.bwa.final.bam.tdf".format(TIME=TIME, subject=SAMPLE_TO_SUBJECT[s], sample=s) for s in config['subject'][subject]]
if 'RNASeq' in config:
	for subject  in config['RNASeq'].keys():
		if subject in SUB_IGV:
			SUB_IGV[subject] += ["{subject}/{TIME}/{sample}/{sample}.star.final.bam".format(TIME=TIME, subject=SUB2RNA[s], sample=s) for s in config['RNASeq'][subject]]
			SUB_IGV[subject] += ["{subject}/{TIME}/{sample}/{sample}.star.final.bam.tdf".format(TIME=TIME, subject=SUB2RNA[s], sample=s) for s in config['RNASeq'][subject]]
		else:
			SUB_IGV[subject] = []
			SUB_IGV[subject] += ["{subject}/{TIME}/{sample}/{sample}.star.final.bam".format(TIME=TIME, subject=SUB2RNA[s], sample=s) for s in config['RNASeq'][subject]]
			SUB_IGV[subject] += ["{subject}/{TIME}/{sample}/{sample}.star.final.bam.tdf".format(TIME=TIME, subject=SUB2RNA[s], sample=s) for s in config['RNASeq'][subject]]
		TARGET += ["{subject}/{TIME}/{sample}/{sample}.tophat.final.bam.tdf".format(TIME=TIME, subject=SUB2RNA[s], sample=s) for s in config['RNASeq'][subject]]
TARGET +=SUB_IGV.values()
############
##	Tiled data file(.tdf)
############
rule BAM2TDF:
	input:
		bam="{base}/{TIME}/{sample}/{sample}.{aligner}.final.bam",
		bam_bai="{base}/{TIME}/{sample}/{sample}.{aligner}.final.bam.bai"
	output:
		"{base}/{TIME}/{sample}/{sample}.{aligner}.final.bam.tdf"
	version: config['igvtools']
	params:
		rulename        = "bamtdf",
		ref             = config["reference"],
		batch           = config[config['host']]['job_igvtools']
	shell:  """
	#######################
	module load igvtools/{version}

	cd ${{LOCAL}}
	java -Xmx${{MEM}}g -Djava.io.tmpdir=${{LOCAL}} -jar $IGVTOOLSHOME/igvtools.jar count {WORK_DIR}/{input.bam} {WORK_DIR}/{output} {params.ref}
	#######################
	"""
