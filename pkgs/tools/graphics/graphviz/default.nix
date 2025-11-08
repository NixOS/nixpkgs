{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  cairo,
  expat,
  flex,
  fontconfig,
  gd,
  gts,
  libjpeg,
  libpng,
  libtool,
  makeWrapper,
  pango,
  bash,
  bison,
  xorg,
  python3,
  withXorg ? true,

  # for passthru.tests
  exiv2,
  fltk,
  graphicsmagick,
}:

let
  inherit (lib) optional optionals optionalString;
in
stdenv.mkDerivation rec {
  pname = "graphviz";
  version = "12.2.1";

  src = fetchFromGitLab {
    owner = "graphviz";
    repo = "graphviz";
    rev = version;
    hash = "sha256-Uxqg/7+LpSGX4lGH12uRBxukVw0IswFPfpb2EkLsaiI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
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
  ]
  ++ optionals withXorg (with xorg; [ libXrender ]);

  hardeningDisable = [ "fortify" ];

  configureFlags = [
    "--with-ltdl-lib=${libtool.lib}/lib"
    "--with-ltdl-include=${libtool}/include"
  ]
  ++ optional (xorg == null) "--without-x";

  enableParallelBuilding = true;

  CPPFLAGS = optionalString (withXorg && stdenv.hostPlatform.isDarwin) "-I${cairo.dev}/include/cairo";

  doCheck = false; # fails with "Graphviz test suite requires ksh93" which is not in nixpkgs

  preAutoreconf = ''
    ./autogen.sh
  '';

  postFixup = optionalString withXorg ''
    substituteInPlace $out/bin/vimdot \
      --replace-warn '"/usr/bin/vi"' '"$(command -v vi)"' \
      --replace-warn '"/usr/bin/vim"' '"$(command -v vim)"' \
      --replace-warn /usr/bin/vimdot $out/bin/vimdot

    wrapProgram $out/bin/vimdot --prefix PATH : "$out/bin"
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
    maintainers = with maintainers; [
      bjornfor
      raskin
    ];
  };
}
