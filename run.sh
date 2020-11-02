#!/bin/bash

mkdir -p compiled images

for i in sources/*.txt tests/*.txt; do
	echo "Compiling: $i"
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done


# Exercise 2
# e)
fstconcat compiled/horas.fst compiled/e_to_dots.fst > compiled/horas_e_dots.fst
fstconcat compiled/horas_e_dots.fst compiled/minutos.fst > compiled/text2num_aux.fst

fstrmepsilon compiled/text2num_aux.fst > compiled/text2num.fst


for i in compiled/*.fst; do
	echo "Creating image: images/$(basename $i '.fst').pdf"
    fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done

echo "Testing the transducer 'converter' with the input 'tests/numero.txt'"
fstcompose compiled/numero.fst compiled/converter.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
