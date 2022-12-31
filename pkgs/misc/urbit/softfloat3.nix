{ stdenv, sources, enableParallelBuilding ? true }:

stdenv.mkDerivation {
  pname = "softfloat3";
  version = sources.softfloat3.rev;
  src = sources.softfloat3;

  postPatch = ''
    for f in $(find build -type f -name 'Makefile'); do
      substituteInPlace $f \
        --replace 'gcc' '$(CC)' \
        --replace 'ar crs' '$(AR) crs'
    done
  '';

  preBuild = ''
    cd build/Linux-x86_64-GCC 
  '';

  installPhase = ''
    mkdir -p $out/{lib,include}
    cp $src/source/include/*.h $out/include/
    cp softfloat.a $out/lib/libsoftfloat3.a
  '';

  inherit enableParallelBuilding;
}

