# README

Code accompanying Gardner et. al. (2019)

For the processed pseudogene discovery pipeline included in the manuscript, please see [this git repo](https://github.com/eugenegardner/Retrogene).

This repo will reproduce all the figures and supplemental data included the paper which were derived from R. Some statistical tests and tabulated numbers are also included.

This repo is an [Rstudio](https://www.rstudio.com/) markdown notebook. For more information on how to use R-markdown please see [this link](https://rmarkdown.rstudio.com/). To use this repo, simply:

```
git clone https://github.com/eugenegardner/MEIPaper.git
cd MEIPaper/
tar -zxvf ./Figures/Supplement/RawData/genodepth.di.tar.gz
tar -zxvf ./Figures/Supplement/RawData/GTEx.expr.tar.gz
tar -zxvf ./Figures/Figure1/RawData/SNV.frq.tar.gz
```

And load the included `MEIPaper.Rproj` file in the top-level directory into Rstudio via `File -> Open Project`.

You can then open the individual `\*.Rmd` notebooks in each of the individual "Figure" folders.

For any questions please open a new github issue.

## To Cite:

<TBD>
