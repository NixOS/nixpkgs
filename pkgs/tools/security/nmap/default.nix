{ stdenv, fetchurl, fetchpatch, libpcap, pkgconfig, openssl, lua5_3
, pcre, liblinear, libssh2
, graphicalSupport ? false
, libX11 ? null
, gtk2 ? null
, python2 ? null
, makeWrapper ? null
, withLua ? true
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "nmap${optionalString graphicalSupport "-graphical"}-${version}";
  version = "7.80";

  src = fetchurl {
    url = "https://nmap.org/dist/nmap-${version}.tar.bz2";
    sha256 = "1aizfys6l9f9grm82bk878w56mg0zpkfns3spzj157h98875mypw";
  };

  patches = [ ./zenmap.patch ]
    ++ optionals stdenv.cc.isClang [(
      # Fixes a compile error due an ambiguous reference to bind(2) in
      # nping/EchoServer.cc, which is otherwise resolved to std::bind.
      # https://github.com/nmap/nmap/pull/1363
      fetchpatch {
        url = "https://github.com/nmap/nmap/commit/5bbe66f1bd8cbd3718f5805139e2e8139e6849bb.diff";
        includes = [ "nping/EchoServer.cc" ];
        sha256 = "0xcph9mycy57yryjg253frxyz87c4135rrbndlqw1400c8jxq70c";
      }
    )];

  prePatch = optionalString stdenv.isDarwin ''
    substituteInPlace libz/configure \
        --replace /usr/bin/libtool ar \
        --replace 'AR="libtool"' 'AR="ar"' \
        --replace 'ARFLAGS="-o"' 'ARFLAGS="-r"'
  '';

  configureFlags = [
    (if withLua then "--with-liblua=${lua5_3}" else "--without-liblua")
  ] ++ optionals (!graphicalSupport) [ "--without-ndiff" "--without-zenmap" ];

  makeFlags = optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "AR=${stdenv.cc.bintools.targetPrefix}ar"
    "RANLIB=${stdenv.cc.bintools.targetPrefix}ranlib"
    "CC=${stdenv.cc.targetPrefix}gcc"
  ];

  pythonPath = with python2.pkgs; optionals graphicalSupport  [
    pygtk pysqlite pygobject2 pycairo
  ];

  nativeBuildInputs = [ pkgconfig ] ++ optionals graphicalSupport [ python2.pkgs.wrapPython ];
  buildInputs = [ pcre liblinear libssh2 libpcap openssl ] ++ optionals graphicalSupport (with python2.pkgs; [
    python2 libX11 gtk2
  ]);

  postInstall = optionalString graphicalSupport ''
    buildPythonPath "$out $pythonPath"
    patchPythonScript $out/bin/ndiff
    patchPythonScript $out/bin/zenmap
  '';

  enableParallelBuilding = true;

  doCheck = false; # fails 3 tests, probably needs the net

  meta = {
    description = "A free and open source utility for network discovery and security auditing";
    homepage    = http://www.nmap.org;
    license     = licenses.gpl2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice fpletz ];
  };
}
