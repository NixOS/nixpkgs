{stdenv, klibc}:

stdenv.mkDerivation {
  name = "${klibc.name}";
  buildCommand = ''
    ensureDir $out/lib
    cp -prd ${klibc}/lib/klibc/bin $out/
    cp -p ${klibc}/lib/*.so $out/lib/
    chmod +w $out/*
    old=$(echo ${klibc}/lib/klibc-*.so)
    new=$(echo $out/lib/klibc-*.so)
    for i in $out/bin/*; do
      echo $i
      sed "s^$old^$new^" -i $i
      # !!! use patchelf
      #patchelf --set-rpath /foo/bar $i
    done
  ''; # */
  allowedReferences = ["out"];
}
