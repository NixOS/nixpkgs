{stdenv, klibc}:

stdenv.mkDerivation {
  # !!! For now, the name has to be exactly as long as the original
  # name due to the sed hackery below.  Once patchelf 0.4 is in the
  # tree, we can do this properly.
  #name = "${klibc.name}-shrunk";
  name = "${klibc.name}";
  buildCommand = ''
    mkdir -p $out/lib
    cp -prd ${klibc.out}/lib/klibc/bin $out/
    cp -p ${klibc.out}/lib/*.so $out/lib/
    chmod +w $out/*
    old=$(echo ${klibc.out}/lib/klibc-*.so)
    new=$(echo $out/lib/klibc-*.so)
    for i in $out/bin/*; do
      echo $i
      sed "s^$old^$new^" -i $i
      # !!! use patchelf
      #patchelf --set-interpreter $new $i
    done
  ''; # */
  allowedReferences = ["out"];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
