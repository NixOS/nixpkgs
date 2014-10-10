if [[ -n "$cargoDeps" ]]; then
   echo "Using cargo deps from $cargoDeps"
   cp -r $cargoDeps deps
   chmod +w deps -R
   export CARGO_HOME=$(realpath deps)
fi
