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
  version = "1.27";
  pname = "fakeroot";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/f/fakeroot/fakeroot_${version}.orig.tar.gz";
    sha256 = "1p5d3jq6l1pzk96agkf05dck7dbgvldx5sg2d4h7d8h230nyni9w";
  };

  patches = lib.optionals stdenv.isLinux [
    ./einval.patch
    (fetchpatch {
      name = "also-wrap-stat-library-call.patch";
      url = "https://sources.debian.org/data/main/f/fakeroot/1.27-1/debian/patches/also-wrap-stat-library-call.patch";
      sha256 = "0p7lq6m31k3rqsnjbi06a8ykdqa3cp4y5ngsjyk3q1269gx59x8b";
    })
  ];

  buildInputs = [ getopt gnused ]
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

  meta = {
    homepage = "https://salsa.debian.org/clint/fakeroot";
    description = "Give a fake root environment through LD_PRELOAD";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [viric];
    platforms = lib.platforms.unix;
  };
}
