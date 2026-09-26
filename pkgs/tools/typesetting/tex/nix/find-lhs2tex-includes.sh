echo '[' > $out
grep '^%include ' $src | cut -d ' ' -f 2 | sed 's/^\(.*\)$/"\1"/' >> $out
echo ']' >> $out
