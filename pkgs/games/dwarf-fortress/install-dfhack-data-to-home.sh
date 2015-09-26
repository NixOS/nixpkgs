if [[ $(readlink $data_dir/hack) != "$pkg_dir/hack" ]]; then
  rm -f $data_dir/hack
  ln -s $pkg_dir/hack $data_dir/hack
fi
if [[ $(readlink $data_dir/dfhack) != "$pkg_dir/dfhack" ]]; then
  rm -f $data_dir/dfhack
  ln -s $pkg_dir/dfhack $data_dir/dfhack
fi
if [[ $(readlink $data_dir/dfhack.init-example) != "$pkg_dir/dfhack.init-example" ]]; then
  rm -f $data_dir/dfhack.init-example
  ln -s $pkg_dir/dfhack.init-example $data_dir/dfhack.init-example
fi
if [[ $(readlink $data_dir/dfhack-run) != "$pkg_dir/dfhack-run" ]]; then
  rm -f $data_dir/dfhack-run
  ln -s $pkg_dir/dfhack-run $data_dir/dfhack-run
fi
