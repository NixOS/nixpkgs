{
  lib,
  stdenv,
  fetchurl,
  libpcap,
  pkg-config,
  openssl,
  lua5_4,
  pcre,
  libssh2,
  withLua ? true,
}:

stdenv.mkDerivation rec {
  pname = "nmap";
  version = "7.94";

  src = fetchurl {
    url = "https://nmap.org/dist/nmap-${version}.tar.bz2";
    sha256 = "sha256-1xvhie7EPX4Jm6yFcVCdMWxFd8p5SRgyrD4SF7yPksw=";
  };

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace libz/configure \
        --replace /usr/bin/libtool ar \
        --replace 'AR="libtool"' 'AR="ar"' \
        --replace 'ARFLAGS="-o"' 'ARFLAGS="-r"'
  '';

  configureFlags = [
    (if withLua then "--with-liblua=${lua5_4}" else "--without-liblua")
    "--with-liblinear=included"
    "--without-ndiff"
    "--without-zenmap"
  ];

  postInstall = ''
    install -m 444 -D nselib/data/passwords.lst $out/share/wordlists/nmap.lst
  '';

  makeFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "AR=${stdenv.cc.bintools.targetPrefix}ar"
    "RANLIB=${stdenv.cc.bintools.targetPrefix}ranlib"
    "CC=${stdenv.cc.targetPrefix}gcc"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    pcre
    libssh2
    libpcap
    openssl
  ];

  enableParallelBuilding = true;

  doCheck = false; # fails 3 tests, probably needs the net

  meta = with lib; {
    description = "A free and open source utility for network discovery and security auditing";
    homepage = "http://www.nmap.org";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [
      thoughtpolice
      fpletz
    ];
  };
}
