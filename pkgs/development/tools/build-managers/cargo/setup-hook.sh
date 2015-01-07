if [[ $cargoDeps ]]; then
   echo "Using cargo deps from $cargoDeps"
   cp -r $cargoDeps deps
   chmod +w deps -R
   export HOME=$(realpath deps)
fi
