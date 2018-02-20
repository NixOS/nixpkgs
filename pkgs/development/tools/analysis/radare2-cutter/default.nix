{ stdenv, fetchFromGitHub, fetchpatch, qmake, pkgconfig, qtbase, qtsvg, radare2 }:


stdenv.mkDerivation rec {
  name = "radare2-cutter-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = "cutter";
    rev = "v${version}";
    sha256 = "02m5sf45n455hn34y7hrqanj830rc5xhz2ppp1z3mzbz0s515pfl";
  };

  postUnpack = "export sourceRoot=$sourceRoot/src";

  patches = [
    # Fixup version number :D
    (fetchpatch {
      url = "https://github.com/radareorg/cutter/commit/69506b64600df632afdca8b680baa7d946c78644.patch";
      sha256 = "0ks3ixz8bycjcfi26bd0p6z7qaplhq00alw44hsfzpdm4bmr01x0";
    })
    (fetchpatch {
      url = "https://github.com/radareorg/cutter/commit/8b52c66f4f0091cd9d97389b32aa519c2c602e2b.patch";
      sha256 = "0wcdn35lx2943pfzm7mkg4sr82pm0qz3yxf74m8fxbd70s3w0gkm";
    })

    # case-insensitive filtering
    (fetchpatch {
      url = "https://github.com/radareorg/cutter/commit/0ebd34370bcaed00000168147572bb78106eeab1.patch";
      sha256 = "0sc50jwhncfnd2i5mlyld4dbdzi2ws7nh4yglkhlap9l9h1jxn20";
    })
  ];

  patchFlags = [ "-p2" ];

  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [ qtbase qtsvg radare2 ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A Qt and C++ GUI for radare2 reverse engineering framework";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
