{ lib, stdenv, fetchurl, fetchpatch, libpcap, pkg-config, openssl, lua5_3
, pcre, libssh2
, libX11 ? null
, gtk2 ? null
, makeWrapper ? null
, withLua ? true
}:

stdenv.mkDerivation rec {
  pname = "nmap";
  version = "7.93";

  src = fetchurl {
    url = "https://nmap.org/dist/nmap-${version}.tar.bz2";
    sha256 = "sha256-Vbz+R5PiWsyWukJ02MQijbVQuOjv1yAEs47FWi3RZlE=";
  };

  patches = [ ./zenmap.patch ]
    ++ lib.optionals stdenv.cc.isClang [(
      # Fixes a compile error due an ambiguous reference to bind(2) in
      # nping/EchoServer.cc, which is otherwise resolved to std::bind.
      # https://github.com/nmap/nmap/pull/1363
      fetchpatch {
        url = "https://github.com/nmap/nmap/commit/5bbe66f1bd8cbd3718f5805139e2e8139e6849bb.diff";
        includes = [ "nping/EchoServer.cc" ];
        sha256 = "0xcph9mycy57yryjg253frxyz87c4135rrbndlqw1400c8jxq70c";
      }
    )];

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace libz/configure \
        --replace /usr/bin/libtool ar \
        --replace 'AR="libtool"' 'AR="ar"' \
        --replace 'ARFLAGS="-o"' 'ARFLAGS="-r"'
  '';

  configureFlags = [
    (if withLua then "--with-liblua=${lua5_3}" else "--without-liblua")
    "--with-liblinear=included"
    "--without-ndiff"
    "--without-zenmap"
  ];

  makeFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "AR=${stdenv.cc.bintools.targetPrefix}ar"
    "RANLIB=${stdenv.cc.bintools.targetPrefix}ranlib"
    "CC=${stdenv.cc.targetPrefix}gcc"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pcre libssh2 libpcap openssl ];

  enableParallelBuilding = true;

  doCheck = false; # fails 3 tests, probably needs the net

  meta = with lib; {
    description = "A free and open source utility for network discovery and security auditing";
    homepage    = "http://www.nmap.org";
    license     = licenses.gpl2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice fpletz ];
  };
}
