#!/bin/bash

mkdir -p compiled images

for i in compiled/*.fst images/*.pdf; do
	echo "Removing file: compiled/$(basename $i '.fst')"
    rm $i
done

for i in sources/*.txt tests/*.txt; do
	echo "Compiling: $i"
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done

# Exercise 2

# e)
fstconcat compiled/horas.fst compiled/e_to_dots.fst > compiled/horas_e_dots_aux.fst
fstconcat compiled/horas_e_dots_aux.fst compiled/minutos.fst > compiled/text2num.fst

# f)
fstconcat compiled/horas.fst compiled/eps_to_dots_horas.fst > compiled/lazy2num_aux.fst
fstunion  compiled/lazy2num_aux.fst compiled/text2num.fst > compiled/lazy2num_aux_2.fst

fstrmepsilon compiled/lazy2num_aux_2.fst > compiled/lazy2num.fst

# g)
fstunion compiled/quartos.fst compiled/meias.fst > compiled/meias_quartos_aux.fst
fstproject compiled/horas.fst > compiled/horas_aux_1.fst
fstconcat compiled/horas_aux_1.fst compiled/hora_to_eps_e.fst > compiled/horas_aux_2.fst
fstconcat compiled/horas_aux_2.fst compiled/meias_quartos_aux.fst > compiled/rich2text_aux.fst

fstrmepsilon compiled/rich2text_aux.fst > compiled/rich2text.fst

# h)  
fstcompose compiled/rich2text.fst compiled/text2num.fst | fstarcsort > compiled/rich2num_1_aux.fst
fstunion  compiled/rich2num_1_aux.fst   compiled/lazy2num.fst > compiled/rich2num_2_aux.fst

fstrmepsilon compiled/rich2num_2_aux.fst > compiled/rich2num.fst

# i)
fstinvert compiled/text2num.fst > compiled/num2text_aux.fst

fstrmepsilon compiled/num2text_aux.fst > compiled/num2text.fst

for i in compiled/*_aux*.fst; do
	echo "Removing aux file: compiled/$(basename $i '.fst')"
    rm $i
done

# TESTS

echo "Testing the transducer 'converter' with the input 'tests/numero.txt'"
fstcompose compiled/numero.fst compiled/converter.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
fstcompose compiled/numero.fst compiled/converter.fst > compiled/numero_result.fst

echo "Testing the Transducer rich2num"
for i in compiled/sleepH_*.fst compiled/wakeupH_*.fst; do
    echo "Testing the transducer 'rich2num' with the input compiled/$(basename $i '.fst')"  
    fstcompose $i compiled/rich2num.fst > compiled/$(basename $i '.fst')_result.fst
done

echo "Testing the Transducer num2text"
for i in compiled/sleepI_*.fst compiled/wakeupI_*.fst; do
    echo "Testing the transducer 'num2text' with the input compiled/$(basename $i '.fst')"  
    fstcompose $i compiled/num2text.fst > compiled/$(basename $i '.fst')_result.fst
done

for i in compiled/*.fst; do
	echo "Creating image: images/$(basename $i '.fst').pdf"
    fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done