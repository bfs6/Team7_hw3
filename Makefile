all: hw3.html

hw3.html: hw3.Rmd data/lq.Rdata data/dennys.Rdata
	R --vanilla <  -e "library(rmarkdown);render('hw3.Rmd')"

data/lq.Rdata: parse_lq.R data/lq/
	R --vanilla <  parse_lq.R

data/dennys.Rdata: parse_dennys.R data/dennys/
	R --vanilla <  parse_dennys.R

data/lq/: get_lq.R
	R --vanilla <  get_lq.R

data/dennys/: get_dennys.R
	R --vanilla < get_dennys.R

clean:
	rm -f hw3.html
	rm -rf data/

.PHONY: clean