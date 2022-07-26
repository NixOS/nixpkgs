{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, which
, enableStatic ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  version = "1.4.2";
  pname = "rhash";

  src = fetchFromGitHub {
    owner = "rhash";
    repo = "RHash";
    rev = "v${version}";
    sha256 = "sha256-HkDgWwHoRWCNtWyfP4sj3veEd+KT5J7yL4J4Z/hJcrE=";
  };

  patches = [
    # Fix clang configuration; remove with next release
    (fetchpatch {
      url = "https://github.com/rhash/RHash/commit/4dc506066cf1727b021e6352535a8bb315c3f8dc.patch";
      sha256 = "0i5jz2s37h278c8d36pzphhp8rjy660zmhpg2cqlp960f6ny8wwj";
    })
  ];

  nativeBuildInputs = [ which ];

  # configure script is not autotools-based, doesn't support these options
  dontAddStaticConfigureFlags = true;

  configurePlatforms = [ ];

  configureFlags = [
    "--ar=${stdenv.cc.targetPrefix}ar"
    "--target=${stdenv.hostPlatform.config}"
    (lib.enableFeature enableStatic "static")
    (lib.enableFeature enableStatic "lib-static")
  ];

  doCheck = true;

  checkTarget = "test-full";

  installTargets = [
    "install"
    "install-lib-headers"
  ] ++ lib.optional (!enableStatic) [
    "install-lib-so-link"
  ];

  meta = with lib; {
    homepage = "http://rhash.sourceforge.net/";
    description = "Console utility and library for computing and verifying hash sums of files";
    license = licenses.bsd0;
    platforms = platforms.all;
    maintainers = with maintainers; [ andrewrk ];
  };
}
