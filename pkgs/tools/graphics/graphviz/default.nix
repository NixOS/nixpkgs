{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  buildPackages,
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
  runCommand,
  bash,
  bison,
  libxrender,
  python3,
  withXorg ? true,

  # for passthru.tests
  exiv2,
  fltk,
  graphicsmagick,
}:

let
  inherit (lib)
    optionals
    optionalString
    optionalAttrs
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "graphviz";
  version = "12.2.1";

  src = fetchFromGitLab {
    owner = "graphviz";
    repo = "graphviz";
    rev = finalAttrs.version;
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
  ++ optionals withXorg [ libxrender ];

  hardeningDisable = [ "fortify" ];

  configureFlags = [
    "--with-ltdl-lib=${libtool.lib}/lib"
    "--with-ltdl-include=${libtool}/include"
    (lib.withFeature withXorg "x")
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  env = optionalAttrs (withXorg && stdenv.hostPlatform.isDarwin) {
    CPPFLAGS = "-I${cairo.dev}/include/cairo";
  };

  doCheck = false; # fails with "Graphviz test suite requires ksh93" which is not in nixpkgs

  preAutoreconf = ''
    ./autogen.sh
  '';

  # Invoke `dot -c` even while cross compiling else lib/graphviz/config6 will not load at runtime.
  postPatch = ''
    substituteInPlace cmd/dot/Makefile.am --replace-fail \
      'if test "x$(DESTDIR)" = "x" -a "x$(build)" = "x$(host)"; then if test -x $(bindir)/dot$(EXEEXT); then if test -x /sbin/ldconfig; then /sbin/ldconfig 2>/dev/null; fi; cd $(bindir); ./dot$(EXEEXT) -c; else cd $(bindir); ./dot_static$(EXEEXT) -c; fi; fi' \
      '${lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
        if test -x $(bindir)/dot$(EXEEXT); then \
          cd $(bindir); ${stdenv.hostPlatform.emulator buildPackages} ./dot$(EXEEXT) -c; \
        else \
          cd $(bindir); ${stdenv.hostPlatform.emulator buildPackages} ./dot_static$(EXEEXT) -c; \
        fi
      ''}'
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
    dot-can-load-plugins =
      runCommand "dot-can-load-plugins"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          dot -P -o $out
        '';
  };

  meta = {
    homepage = "https://graphviz.org";
    description = "Graph visualization tools";
    license = lib.licenses.epl10;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      bjornfor
      raskin
    ];
  };
})
