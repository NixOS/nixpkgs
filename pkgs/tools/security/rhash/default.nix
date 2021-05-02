{ lib, stdenv, fetchFromGitHub, which
, isStatic ? stdenv.hostPlatform.isStatic
, fetchpatch
}:

stdenv.mkDerivation rec {
  version = "1.4.1";
  pname = "rhash";

  src = fetchFromGitHub {
    owner = "rhash";
    repo = "RHash";
    rev = "v${version}";
    sha256 = "sha256-kmi1FtJYPBUdMfJlzEsQkTwcYB99isP3yzH1EYlk54g=";
  };

  patches = [
    ( fetchpatch {
      url = "https://github.com/rhash/RHash/pull/160/commits/ff3cfb65e4d8ed64a40d61213c36f328c1e44aef.patch";
      sha256 = "1ppir5is2nr4bvsx7d19qcd15qdscg43fr3chqzbv19z85n2yzh8";
    })
  ];

  nativeBuildInputs = [
    which
  ] ++ lib.optionals isStatic [
    # needed for ar
    stdenv.cc.bintools.bintools
  ];

  preConfigure = ''
    patchShebangs configure
  '';

  # configure script is not autotools-based, doesn't support these options
  configurePlatforms = [ ];
  configureFlags = lib.optionals isStatic [
    "--enable-static"
    "--enable-lib-static"
    "--disable-lib-shared"
  ];

  makeFlags = lib.optionals isStatic [
    "lib-static"
  ];

  doCheck = true;

  checkTarget = "test-full";

  installTargets = [
    "install"
    "install-lib-headers"
  ] ++ lib.optionals (!isStatic) [
    "install-lib-so-link"
    "install-lib-shared"
  ] ++ lib.optionals isStatic [
    "install-lib-static"
  ];

  meta = with lib; {
    homepage = "http://rhash.sourceforge.net/";
    description = "Console utility and library for computing and verifying hash sums of files";
    license = licenses.bsd0;
    platforms = platforms.all;
    maintainers = [ maintainers.andrewrk ];
  };
}
