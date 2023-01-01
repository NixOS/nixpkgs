{ stdenv
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "softfloat3";
  version = "ec4c7e31b32e07aad80e52f65ff46ac6d6aad986";
  src = fetchFromGitHub {
    owner = "urbit";
    repo = "berkeley-softfloat-3";
    rev = "ec4c7e31b32e07aad80e52f65ff46ac6d6aad986";
    sha256 = "1lz4bazbf7lns1xh8aam19c814a4n4czq5xsq5rmi9sgqw910339";
  };

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

  meta = {
    description = "C implementation of binary floating-point";
    homepage = "https://github.com/urbit/berkeley-softfloat-3";
    license = lib.licenses.free;
    maintainers = [ lib.maintainers.uningan ];
    platforms = lib.platforms.unix;
  };
}
