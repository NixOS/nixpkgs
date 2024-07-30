{ lib
, stdenv
, fetchFromGitLab
, autoreconfHook
, pkg-config
, cairo
, expat
, flex
, fontconfig
, gd
, gts
, libjpeg
, libpng
, libtool
, pango
, bash
, bison
, xorg
, ApplicationServices
, Foundation
, python3
, withXorg ? true

# for passthru.tests
, exiv2
, fltk
, graphicsmagick
}:

let
  inherit (lib) optional optionals optionalString;
in
stdenv.mkDerivation rec {
  pname = "graphviz";
  version = "10.0.1";

  src = fetchFromGitLab {
    owner = "graphviz";
    repo = "graphviz";
    rev = version;
    hash = "sha256-KAqJUVqPld3F2FHlUlfbw848GPXXOmyRQkab8jlH1NM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
    bison
    flex
  ];

  buildInputs = [
    libpng
    libjpeg
    expat
    fontconfig
    gd
    gts
    pango
    bash
  ] ++ optionals withXorg (with xorg; [ libXrender libXaw libXpm ])
  ++ optionals stdenv.isDarwin [ ApplicationServices Foundation ];

  hardeningDisable = [ "fortify" ];

  configureFlags = [
    "--with-ltdl-lib=${libtool.lib}/lib"
    "--with-ltdl-include=${libtool}/include"
  ] ++ optional (xorg == null) "--without-x";

  enableParallelBuilding = true;

  CPPFLAGS = optionalString (withXorg && stdenv.isDarwin)
    "-I${cairo.dev}/include/cairo";

  doCheck = false; # fails with "Graphviz test suite requires ksh93" which is not in nixpkgs

  preAutoreconf = ''
    # components under this directory require a tool `CompileXIB` to build
    # and there's no official way to disable this on darwin.
    substituteInPlace Makefile.am --replace-fail 'SUBDIRS += macosx' ""

    ./autogen.sh
  '';

  postFixup = optionalString withXorg ''
    substituteInPlace $out/bin/vimdot \
      --replace '"/usr/bin/vi"' '"$(command -v vi)"' \
      --replace '"/usr/bin/vim"' '"$(command -v vim)"' \
      --replace /usr/bin/vimdot $out/bin/vimdot \
  '';

  passthru.tests = {
    inherit (python3.pkgs)
      graphviz
      pydot
      pygraphviz
      xdot
    ;
    inherit
      exiv2
      fltk
      graphicsmagick
    ;
  };

  meta = with lib; {
    homepage = "https://graphviz.org";
    description = "Graph visualization tools";
    license = licenses.epl10;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor raskin ];
  };
}
