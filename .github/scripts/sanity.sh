#!/usr/bin/env bash
set -e

echo "=== Dev-Stack Sanity Check ==="

echo "--- Python ---"
which python3
python3 --version
pip --version

echo "--- NumPy / Pandas ---"
python3 -c "import numpy, pandas; print('NumPy', numpy.__version__, 'Pandas', pandas.__version__)"

echo "--- TA-Lib ---"
python3 -c "import talib, numpy as np; print('RSI test:', talib.RSI(np.arange(1,10,dtype=float), timeperiod=3))"

echo "--- Pandas TA Classic ---"
python3 -c "import pandas_ta_classic as ta; print('TA Classic OK, sample funcs:', [f for f in dir(ta) if not f.startswith('_')][:5])"

echo "--- Finance / Analysis libs ---"
python3 -c "import ccxt, sqlalchemy, zipline; print('CCXT', ccxt.__version__, 'SQLAlchemy', sqlalchemy.__version__)"

echo "--- PATH ---"
echo $PATH | tr ':' '\n' | head

echo "=== Sanity check complete ✅ ==="
