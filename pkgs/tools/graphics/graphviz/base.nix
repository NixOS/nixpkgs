{ rev, sha256, version }:

{ stdenv, fetchFromGitLab, autoreconfHook, pkgconfig, cairo, expat, flex
, fontconfig, gd, gettext, gts, libdevil, libjpeg, libpng, libtool, pango
, yacc, xorg ? null, ApplicationServices ? null }:

assert stdenv.isDarwin -> ApplicationServices != null;

let
  inherit (stdenv.lib) optional optionals optionalString;
in

stdenv.mkDerivation rec {
  name = "graphviz-${version}";

  src = fetchFromGitLab {
    owner = "graphviz";
    repo = "graphviz";
    inherit sha256 rev;
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [
    libpng libjpeg expat yacc libtool fontconfig gd gts libdevil flex pango
    gettext
  ] ++ optionals (xorg != null) (with xorg; [ libXrender libXaw libXpm ])
    ++ optionals (stdenv.isDarwin) [ ApplicationServices ];

  hardeningDisable = [ "fortify" ];

  CPPFLAGS = stdenv.lib.optionalString (xorg != null && stdenv.isDarwin)
    "-I${cairo.dev}/include/cairo";

  configureFlags = [
    "--with-ltdl-lib=${libtool.lib}/lib"
    "--with-ltdl-include=${libtool}/include"
  ] ++ stdenv.lib.optional (xorg == null) [ "--without-x" ];

  postPatch = ''
    for f in $(find . -name Makefile.in); do
      substituteInPlace $f --replace "-lstdc++" "-lc++"
    done
  '';

  preAutoreconf = "./autogen.sh";

  postFixup = optionalString (xorg != null) ''
    substituteInPlace $out/bin/dotty --replace '`which lefty`' $out/bin/lefty
    substituteInPlace $out/bin/vimdot \
      --replace /usr/bin/vi '$(command -v vi)' \
      --replace /usr/bin/vim '$(command -v vim)' \
      --replace /usr/bin/vimdot $out/bin/vimdot \
  '';

  meta = with stdenv.lib; {
    homepage = https://graphviz.org;
    description = "Graph visualization tools";
    license = licenses.epl10;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor raskin ];
  };
}
