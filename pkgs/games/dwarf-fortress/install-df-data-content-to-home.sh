find $pkg_dir/data -mindepth 1 -maxdepth 1 ! -name 'init' -printf "%f\n" | while read link
do
  cp -rT $pkg_dir/data/$link "$data_dir/data/$link"
  chmod -R u+rw "$data_dir/data/$link"
done
