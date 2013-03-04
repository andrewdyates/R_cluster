#!/usr/bin/python
"""Load pickled numpy matrix, remove non-significant rows and columns, save as text.
"""
import matrix_io as mio
from lab_util import *
import cPickle as pickle
import sys
import os
import datetime
import rpy2


def main(pkl_fname=None, row_fname=None, col_fname=None, outdir=None, sig=None, abs=False):
  """
  pkl_fname: path to pickled numpy dependency matrix
  row_fname: path to labeled text matrix with row ids, maybe col ids
  col_fname: optional path to labeled text matrix with col ids
  sig: float of minimum significance
  abs: flag of whether to use absolute value for significance testing
  """
  assert pkl_fname and row_fname and outdir
  make_dir(outdir)
  out_fname = os.path.join(outdir, os.path.basename(pkl_fname.rpartition('.')[0])+".sig=%s.abs=%s.tab"%(str(sig),str(abs)))
  print "Text matrix will be saved to: %s" % out_fname
  M = pickle.load(open(pkl_fname))

  # Get row and column labels.
  D_row = mio.load(row_fname)
  row_names = np.array(D_row['row_ids'])
  if col_fname is None:
    col_names = np.array(D_row['col_ids'])
  else:
    D_col = mio.load(col_fname)
    col_names = np.array(D_col['row_ids'])

  # Remove insignificant rows and columns; align row/col names
  original_dim = M.shape
  if sig is not None:
    if not abs:
      col_max = np.amax(M,0)
      row_max = np.amax(M,1)
    else:
      col_max = np.amax(np.abs(M),0)
      row_max = np.amax(np.abs(M),1)
    M = M[row_max>=sig, col_max>=sig]
    row_names = row_names[row_max>=sig]
    col_names = col_names[col_max>=sig]
  new_dim = M.shape

  # Dump to text
  now_timestamp = datetime.datetime.now().isoformat('_')
  header = ["Generated on %s from pickled matrix file %s" % (now_timestamp, pkl_fname),
            "Original dimensions: %s, New dimensions: %s" % (original_dim, new_dim),
            "sig: %s, abs: %s" % (str(sig), str(abs))]
  print "\n".join(header)
  fp = open(out_fname, "w")
  mio.save(M, fp, ftype="tab", row_ids=row_names, col_ids=col_names, headers=header)
  fp.close()
  print "Tab matrix saved to %s." % out_fname
  
  return {'tab': out_fname, 'RData': r_fname}


if __name__ == "__main__":
  argv = dict([s.split('=') for s in sys.argv[1:]])
  print argv
  main(**argv)
