#!/bin/bash

mkdir -p compiled images

for i in sources/*.txt tests/*.txt; do
	echo "Compiling: $i"
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done


# Exercise 2

# e)
fstconcat compiled/horas.fst compiled/e_to_dots.fst > compiled/horas_e_dots_aux.fst
fstconcat compiled/horas_e_dots_aux.fst compiled/minutos.fst > compiled/text2num_aux.fst

fstrmepsilon compiled/text2num_aux.fst > compiled/text2num.fst

# f)
fstconcat compiled/horas.fst compiled/eps_to_dots_hours.fst > compiled/lazy2num_aux.fst

fstrmepsilon compiled/lazy2num_aux.fst > compiled/lazy2num.fst

# g)
fstunion compiled/quartos.fst compiled/meias.fst > compiled/meias_quartos_aux.fst
fstconcat compiled/hora_to_hora.fst compiled/meias_quartos_aux.fst > compiled/rich2text_aux.fst

fstrmepsilon compiled/rich2text_aux.fst > compiled/rich2text.fst

# h)
fstconcat compiled/rich2text.fst compiled/text2num.fst > compiled/rich2num_1_aux.fst
fstunion  compiled/rich2num_1_aux.fst   compiled/lazy2num.fst > compiled/rich2num_2_aux.fst
fstunion  compiled/rich2num_2_aux.fst   compiled/text2num.fst > compiled/rich2num_3_aux.fst

fstrmepsilon compiled/rich2num_3_aux.fst > compiled/rich2num.fst

# i)
fstinvert compiled/rich2num.fst > compiled/num2text_aux.fst

fstrmepsilon compiled/num2text_aux.fst > compiled/num2text.fst

for i in compiled/*_aux.fst; do
	echo "Removing aux file: compiled/$(basename $i '.fst')"
    rm $i
done

for i in compiled/*.fst; do
	echo "Creating image: images/$(basename $i '.fst').pdf"
    fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done

echo "Testing the transducer 'converter' with the input 'tests/numero.txt'"
fstcompose compiled/numero.fst compiled/converter.fst | fstshortestpath | fstproject --project_output=true | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
