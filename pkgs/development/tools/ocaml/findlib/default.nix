{stdenv, fetchurl, m4, ncurses, ocaml, writeText}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "1.2.6";
in

stdenv.mkDerivation {
  name = "ocaml-findlib-${version}";

  src = fetchurl {
    url = "http://download.camlcity.org/download/findlib-${version}.tar.gz";
    sha256 = "1b6z5lylsjxxaifw2yc21cs0dc84zqi4q57sgwg4j8k3m60ivpxs";
  };

  buildInputs = [m4 ncurses ocaml];

  patches = [ ./ldconf.patch ];

  dontAddPrefix=true;

  preConfigure=''
    configureFlagsArray=(
      -bindir $out/bin
      -mandir $out/share/man
      -sitelib $out/lib/ocaml/${ocaml_version}/site-lib
      -config $out/etc/findlib.conf
      -no-topfind
    )
  '';

  buildPhase = ''
    make all
    make opt
  '';

  setupHook = writeText "setupHook.sh" ''
    addOCamlPath () {
        if test -d "''$1/lib/ocaml/${ocaml_version}/site-lib"; then
            export OCAMLPATH="''${OCAMLPATH}''${OCAMLPATH:+:}''$1/lib/ocaml/${ocaml_version}/site-lib/"
        fi
        export OCAMLFIND_DESTDIR="''$out/lib/ocaml/${ocaml_version}/site-lib/"
        if test -n "$createFindlibDestdir"; then
          ensureDir $OCAMLFIND_DESTDIR
        fi
    }
    
    envHooks=(''${envHooks[@]} addOCamlPath)
  '';

  meta = {
    homepage = http://projects.camlcity.org/projects/findlib.html;
    description = "O'Caml library manager";
    license = "MIT/X11";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
