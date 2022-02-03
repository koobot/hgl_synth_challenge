# HGL Synthetic Challenge

The Australian Bureau of Statistics (ABS) team.

[HGL 2022 Synthetic Data Challenge Event Link](https://indico.un.org/event/1000359/)

There are 3 methods:

1. [Simulated data](#simulated-data)
2. [Classification and Regression Trees (CART)](#cart)
3. [Condition Tabular Generative Adversarial Networks (CTGAN)](#ctgan)

## <a name="simulated-data"></a>1. Simulated Data

Functions are in R package: `ABSsimulateddata_*.tar.gz`. The package was created by Joseph Chien.

## <a name="cart"></a>2. CART

From R `synthpop` package.


## <a name="ctgan"></a>3. CTGAN

Conditional Tabular GAN (CTGAN) is a [python package](https://github.com/sdv-dev/CTGAN).

The `ctgan.ipynb` notebook uses both Python and R.

The `requirements.txt` lists the Python packages for that notebook.

To run the notebook, we have written some [basic install instructions](./install_run_ctgan.md).

## Contributors

- Joseph Chien
- Tenniel Guiver
- Geoffrey Brent
- Jacob Ryan
- Stephanie Koo

## Todo

- Add table of contents
- Fix up all the text in this readme to be more coherent
- CART method
- Privacy evaluation
- Merge `install_run_ctgan.md` with readme??
