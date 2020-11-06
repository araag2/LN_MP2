#!/bin/bash

mkdir -p compiled images

for i in tests/horas/*txt tests/minutos/*.txt tests/meias/*.txt tests/quartos/*.txt; do
	echo "Compiling: $i"
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done

### TESTS

#echo "horas.txt Tests"
#for i in compiled/test_horas_*.fst; do
    #echo "Testing the transducer 'horas' with the input compiled/$(basename $i '.fst')"  
    #fstcompose $i compiled/horas.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
#done

# minutos .txt
#echo "minutos.txt Tests"
#for i in compiled/test_minutos_*.fst; do
    #echo "Testing the transducer 'minutos' with the input compiled/$(basename $i '.fst')"  
    #fstcompose $i compiled/minutos.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
#done

#echo "meias.txt Tests"
#for i in compiled/test_meias_*.fst; do
    #echo "Testing the transducer 'meias' with the input compiled/$(basename $i '.fst')"  
    #fstcompose $i compiled/meias.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
#done

echo "quartos.txt Tests"
for i in compiled/test_quartos_*.fst; do
    echo "Testing the transducer 'quartos' with the input compiled/$(basename $i '.fst')"  
    fstcompose $i compiled/quartos.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
done

for i in compiled/test_*.fst; do
	#echo "Removing test file: compiled/$(basename $i '.fst')"
    rm $i
done

