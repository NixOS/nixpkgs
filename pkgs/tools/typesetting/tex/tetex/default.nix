{
  lib,
  stdenv,
  fetchurl,
  flex,
  bison,
  zlib,
  libpng,
  ncurses,
  ed,
  automake,
}:

stdenv.mkDerivation rec {
  pname = "tetex";
  version = "3.0";

  src = fetchurl {
    url = "https://mirrors.ctan.org/obsolete/systems/unix/teTeX/${version}/distrib/tetex-src-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  texmf = fetchurl {
    url = "https://mirrors.ctan.org/obsolete/systems/unix/teTeX/${version}/distrib/tetex-texmf-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  buildInputs = [
    flex
    bison
    zlib
    libpng
    ncurses
    ed
  ];

  hardeningDisable = [ "format" ];

  # fixes "error: conflicting types for 'calloc'", etc.
  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i 57d texk/kpathsea/c-std.h
  '';

  preConfigure =
    if stdenv.hostPlatform.isCygwin then
      ''
        find ./ -name "config.guess" -exec rm {} \; -exec ln -s ${automake}/share/automake-*/config.guess {} \;
      ''
    else
      null;

  patches = [
    ./environment.patch
    ./getline.patch
    ./clang.patch
    ./extramembot.patch
  ];

  setupHook = ./setup-hook.sh;

  env = {
    CFLAGS = "-std=gnu89";
    CXXFLAGS = "-std=c++03";
  };

  configureFlags =
    [
      "--disable-multiplatform"
      "--without-x11"
      "--without-xdvik"
      "--without-oxdvik"
      "--without-texinfo"
      "--without-texi2html"
      "--with-system-zlib"
      "--with-system-pnglib"
      "--with-system-ncurses"
    ]
    # couldn't get gsftopk working on darwin
    ++ lib.optional stdenv.hostPlatform.isDarwin "--without-gsftopk";

  postUnpack = ''
    mkdir -p $out/share/texmf
    mkdir -p $out/share/texmf-dist
    gunzip < $texmf | (cd $out/share/texmf-dist && tar xvf -)

    substituteInPlace ./tetex-src-3.0/configure --replace /usr/bin/install $(type -P install)
  '';

  meta = with lib; {
    description = "Full-featured (La)TeX distribution";
    homepage = "http://www.tug.org/tetex/";
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.unix;
    hydraPlatforms = [ ];
  };
}
