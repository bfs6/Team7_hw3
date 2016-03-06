all: hw3.html

hw3.html: hw3.Rmd data/lq.Rdata data/dennys.Rdata
	Rscript -e "library(rmarkdown);render('hw3.Rmd')"

data/lq.Rdata: parse_lq.R data/lq/
	Rscript parse_lq.R

data/dennys.Rdata: parse_dennys.R data/dennys/
	Rscript parse_dennys.R

data/lq/: get_lq.R
	Rscript get_lq.R

data/dennys/: get_dennys.R
	Rscript get_dennys.R

clean:
	rm -f hw3.html
	rm -rf data/

.PHONY: clean
