{ runCommand, meta ? {}, lib
, maxima
}:
runCommand "test-maxima" { 
  buildInputs = [maxima];
  meta = lib.recursiveUpdate {
    description = "Check that ${maxima.name} can do a trivial computation";
  } meta;
} ''
  echo 'string(diff(x^2,x));' | maxima --very-quiet | tee log | grep ' 2[*]x$' > $out
''
