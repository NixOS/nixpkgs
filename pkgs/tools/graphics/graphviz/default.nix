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
, libdevil
, libjpeg
, libpng
, libtool
, pango
, bash
, bison
, xorg
, ApplicationServices
, python3
, fltk
, exiv2
, withXorg ? true
}:

let
  inherit (lib) optional optionals optionalString;
in
stdenv.mkDerivation rec {
  pname = "graphviz";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "graphviz";
    repo = "graphviz";
    rev = version;
    sha256 = "sha256-vDqVJJg2ezYGZPp7UtpvWfCypLBqRrr0aPMSyEN+IQo=";
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
    libdevil
    pango
    bash
  ] ++ optionals withXorg (with xorg; [ libXrender libXaw libXpm ])
  ++ optionals stdenv.isDarwin [ ApplicationServices ];

  hardeningDisable = [ "fortify" ];

  configureFlags = [
    "--with-ltdl-lib=${libtool.lib}/lib"
    "--with-ltdl-include=${libtool}/include"
  ] ++ lib.optional (xorg == null) "--without-x";

  enableParallelBuilding = true;

  CPPFLAGS = lib.optionalString (withXorg && stdenv.isDarwin)
    "-I${cairo.dev}/include/cairo";

  # ''
  #   substituteInPlace rtest/rtest.sh \
  #     --replace "/bin/ksh" "${mksh}/bin/mksh"
  # '';

  doCheck = false; # fails with "Graphviz test suite requires ksh93" which is not in nixpkgs

  postPatch = ''
    for f in $(find . -name Makefile.in); do
      substituteInPlace $f --replace "-lstdc++" "-lc++"
    done
  '';

  preAutoreconf = "./autogen.sh";

  postFixup = optionalString withXorg ''
    substituteInPlace $out/bin/vimdot \
      --replace '"/usr/bin/vi"' '"$(command -v vi)"' \
      --replace '"/usr/bin/vim"' '"$(command -v vim)"' \
      --replace /usr/bin/vimdot $out/bin/vimdot \
  '';

  passthru.tests = {
    inherit (python3.pkgs) pygraphviz;
    inherit fltk exiv2;
  };

  meta = with lib; {
    homepage = "https://graphviz.org";
    description = "Graph visualization tools";
    license = licenses.epl10;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor raskin ];
  };
}
