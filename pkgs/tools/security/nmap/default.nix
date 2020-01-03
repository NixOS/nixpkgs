{ stdenv, fetchurl, fetchpatch, libpcap, pkgconfig, openssl, lua5_3
, graphicalSupport ? false
, libX11 ? null
, gtk2 ? null
, withPython ? false # required for the `ndiff` binary
, python2Packages ? null
, makeWrapper ? null
, withLua ? true
}:

assert withPython -> python2Packages != null;

with stdenv.lib;

let

  # Zenmap (the graphical program) also requires Python,
  # so automatically enable pythonSupport if graphicalSupport is requested.
  pythonSupport = withPython || graphicalSupport;

in stdenv.mkDerivation rec {
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
  ]
    ++ optional (!pythonSupport) "--without-ndiff"
    ++ optional (!graphicalSupport) "--without-zenmap"
    ;

  makeFlags = optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "AR=${stdenv.cc.bintools.targetPrefix}ar"
    "RANLIB=${stdenv.cc.bintools.targetPrefix}ranlib"
    "CC=${stdenv.cc.targetPrefix}gcc"
  ];

  postInstall = optionalString pythonSupport ''
      wrapProgram $out/bin/ndiff --prefix PYTHONPATH : "$(toPythonPath $out)" --prefix PYTHONPATH : "$PYTHONPATH"
  '' + optionalString graphicalSupport ''
      wrapProgram $out/bin/zenmap --prefix PYTHONPATH : "$(toPythonPath $out)" --prefix PYTHONPATH : "$PYTHONPATH" --prefix PYTHONPATH : $(toPythonPath $pygtk)/gtk-2.0 --prefix PYTHONPATH : $(toPythonPath $pygobject)/gtk-2.0 --prefix PYTHONPATH : $(toPythonPath $pycairo)/gtk-2.0
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = with python2Packages; [ libpcap openssl ]
    ++ optionals pythonSupport [ makeWrapper python ]
    ++ optionals graphicalSupport [
      libX11 gtk2 pygtk pysqlite pygobject2 pycairo
    ];

  doCheck = false; # fails 3 tests, probably needs the net

  meta = {
    description = "A free and open source utility for network discovery and security auditing";
    homepage    = http://www.nmap.org;
    license     = licenses.gpl2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice fpletz ];
  };
}
