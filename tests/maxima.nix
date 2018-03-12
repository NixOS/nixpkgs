{ runCommand
, maxima
}:
runCommand "test-maxima" { 
  buildInputs = [maxima];
} ''
  echo 'string(diff(x^2,x));' | maxima --very-quiet | tee log | grep ' 2[*]x$' > $out
''
