for link in announcement art dipscript help index initial_movies movies shader.fs shader.vs sound speech; do
  cp -r $pkg_dir/data/$link "$data_dir/data/$link"
  chmod -R u+rw "$data_dir/data/$link"
done
