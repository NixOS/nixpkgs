mkdir -p $data_dir
if [[ $(readlink $data_dir/raw) != "$pkg_dir/raw" ]]; then
  rm -f $data_dir/raw
  ln -s $pkg_dir/raw $data_dir/raw
fi
if [[ $(readlink $data_dir/libs) != "$pkg_dir/libs" ]]; then
  rm -f $data_dir/libs
  ln -s $pkg_dir/libs $data_dir/libs
fi
mkdir -p "$data_dir/data"
cp -rn $pkg_dir/data/init $data_dir/data/init
chmod -R u+rw $data_dir/data/init
