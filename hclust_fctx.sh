#PBS -N SaveToText
#PBS -l nodes=1:ppn=12
#PBS -j oe
#PBS -m ea
#PBS -S /bin/bash
#PBS -l walltime=4:00:00

#tdate=$(date +%%T)

set -x
cd /nfs/01/osu6683/
source .bash_profile

cd $HOME

/usr/bin/time python $HOME/pymod/pkl_txt_RData/pkl_to_RData.py pkl_fname=/fs/lustre/osu6683/gse15745_feb27_dep/fctx_aligned_dual/compiled_dep_matrices/gibbs.meth.fctx.aligned.psb.corr.feb-15-2013.pkl_gibbs.mrna.fctx.aligned.psb.corr.feb-15-2013.pkl.DCOR.values.pkl row_fname=$HOME/gibbs_feb16_cleaned_data/gibbs.meth.fctx.aligned.psb.corr.feb-15-2013.tab col_fname=$HOME/gibbs_feb16_cleaned_data/gibbs.mrna.fctx.aligned.psb.corr.feb-15-2013.tab outdir=/fs/lustre/osu6683 
