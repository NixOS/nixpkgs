{ lib
, stdenv
, fetchurl
, fetchpatch
, getopt
, libcap
, gnused
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "fakeroot";
  version = "1.29";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/f/fakeroot/fakeroot_${version}.orig.tar.gz";
    hash = "sha256-j7uvt4DJFz46zkoEr7wdkA8zfzIWiDk59cfbNDG+fCA=";
  };

  patches = lib.optionals stdenv.isLinux [
    ./einval.patch
    (fetchpatch {
      name = "also-wrap-stat-library-call.patch";
      url = "https://sources.debian.org/data/main/f/fakeroot/1.29-1/debian/patches/also-wrap-stat-library-call.patch";
      hash = "sha256-C/VU+ktGBDyml/rZ4sllQ+E2PVIGxCWtxnnMMKrB9Fw=";
    })
  ];

  nativeBuildInputs = [ getopt ];

  buildInputs = [ gnused ]
    ++ lib.optional (!stdenv.isDarwin) libcap
    ;

  postUnpack = ''
    sed -i -e "s@getopt@$(type -p getopt)@g" -e "s@sed@$(type -p sed)@g" ${pname}-${version}/scripts/fakeroot.in
  '';

  passthru = {
    tests = {
      # A lightweight *unit* test that exercises fakeroot and fakechroot together:
      nixos-etc = nixosTests.etc.test-etc-fakeroot;
    };
  };

  meta = with lib; {
    homepage = "https://salsa.debian.org/clint/fakeroot";
    description = "Give a fake root environment through LD_PRELOAD";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.unix;
  };
}
