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
, withXorg ? true
}:

let
  inherit (lib) optional optionals optionalString;
in
stdenv.mkDerivation {
  pname = "graphviz";
  version = "2.50.0";

  src = fetchFromGitLab {
    owner = "graphviz";
    repo = "graphviz";
    # use rev as tags have disappeared before
    rev = "ca43e4c6a217650447e2928c2e9cb493c73ebd7d";
    sha256 = "1psfgr8y4hh9yyzl04f7xbqb2y9k1xbja051j6b06q9dx7bmkmky";
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
    substituteInPlace $out/bin/dotty --replace '`which lefty`' $out/bin/lefty
    substituteInPlace $out/bin/vimdot \
      --replace /usr/bin/vi '$(command -v vi)' \
      --replace /usr/bin/vim '$(command -v vim)' \
      --replace /usr/bin/vimdot $out/bin/vimdot \
  '';

  meta = with lib; {
    homepage = "https://graphviz.org";
    description = "Graph visualization tools";
    license = licenses.epl10;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor raskin ];
  };
}
