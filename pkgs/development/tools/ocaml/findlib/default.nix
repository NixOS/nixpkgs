{ stdenv, fetchurl, fetchpatch, m4, ncurses, ocaml, writeText }:

stdenv.mkDerivation rec {
  name = "ocaml-findlib-${version}";
  version = "1.7.3";

  src = fetchurl {
    url = "http://download.camlcity.org/download/findlib-${version}.tar.gz";
    sha256 = "12xx8si1qv3xz90qsrpazjjk4lc1989fzm97rsmc4diwla7n15ni";
  };

  buildInputs = [m4 ncurses ocaml];

  patches = [ ./ldconf.patch ./install_topfind.patch
    (fetchpatch {
      url = "https://raw.githubusercontent.com/ocaml/opam-repository/1f29c5ef8eccd373e5ff2169a30bfd95a9ae6050/packages/ocamlfind/ocamlfind.1.7.3-1/files/threads.patch";
      sha256 = "0cqgpjqpmfbr0ph3jr25gw8hgckj4qlfwmir6vkgi5hvn2qnjpx3";
    })
  ];

  dontAddPrefix=true;

  preConfigure=''
    configureFlagsArray=(
      -bindir $out/bin
      -mandir $out/share/man
      -sitelib $out/lib/ocaml/${ocaml.version}/site-lib
      -config $out/etc/findlib.conf
    )
  '';

  buildPhase = ''
    make all
    make opt
  '';

  setupHook = writeText "setupHook.sh" ''
    addOCamlPath () {
        if test -d "''$1/lib/ocaml/${ocaml.version}/site-lib"; then
            export OCAMLPATH="''${OCAMLPATH}''${OCAMLPATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/"
        fi
        if test -d "''$1/lib/ocaml/${ocaml.version}/site-lib/stubslibs"; then
            export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/stubslibs"
        fi
        export OCAMLFIND_DESTDIR="''$out/lib/ocaml/${ocaml.version}/site-lib/"
        if test -n "$createFindlibDestdir"; then
          mkdir -p $OCAMLFIND_DESTDIR
        fi
    }

    addEnvHooks "$targetOffset" addOCamlPath
  '';

  meta = {
    homepage = http://projects.camlcity.org/projects/findlib.html;
    description = "O'Caml library manager";
    license = stdenv.lib.licenses.mit;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.z77z
      stdenv.lib.maintainers.vbmithr
    ];
  };
}


