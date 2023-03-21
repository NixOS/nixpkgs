{ lib, stdenv, fetchurl, makeWrapper, writeText
, graphviz, doxygen
, ocamlPackages, ltl2ba, coq, why3
, gdk-pixbuf, wrapGAppsHook
}:

let why3_1_5 = why3.overrideAttrs (o: rec {
    version = "1.5.1";
    src = fetchurl {
      url = "https://why3.gitlabpages.inria.fr/releases/${o.pname}-${version}.tar.gz";
      hash = "sha256-vNR7WeiSvg+763GcovoZBFDfncekJMeqNegP4fVw06I=";
    };
  }); in
let why3 = why3_1_5; in

let
  mkocamlpath = p: "${p}/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib";
  runtimeDeps = with ocamlPackages; [
    apron.dev
    bigarray-compat
    biniou
    camlzip
    easy-format
    menhirLib
    mlgmpidl
    num
    ocamlgraph
    ppx_deriving
    ppx_deriving_yojson
    ppx_import
    stdlib-shims
    why3
    re
    result
    seq
    sexplib
    sexplib0
    parsexp
    base
    yojson
    zarith
  ];
  ocamlpath = lib.concatMapStringsSep ":" mkocamlpath runtimeDeps;
in

stdenv.mkDerivation rec {
  pname = "frama-c";
  version = "26.1";
  slang   = "Iron";

  src = fetchurl {
    url  = "https://frama-c.com/download/frama-c-${version}-${slang}.tar.gz";
    hash = "sha256-UT7ajIyu8e5vzrz2oBKDDrtZqUacgUP/TRi0/kz9Qkg=";
  };

  postConfigure = "patchShebangs src/plugins/eva/gen-api.sh";

  strictDeps = true;

  nativeBuildInputs = [ wrapGAppsHook ] ++ (with ocamlPackages; [ ocaml findlib dune_3 ]);

  buildInputs = with ocamlPackages; [
    dune-site dune-configurator
    ltl2ba ocamlgraph yojson menhirLib camlzip
    lablgtk3 lablgtk3-sourceview3 coq graphviz zarith apron why3 mlgmpidl doxygen
    ppx_deriving ppx_import ppx_deriving_yojson
    gdk-pixbuf
  ];

  buildPhase = ''
    runHook preBuild
    dune build -j$NIX_BUILD_CORES --release @install
    runHook postBuild
  '';

  installFlags = [ "PREFIX=$(out)" ];

  preFixup = ''
     gappsWrapperArgs+=(--prefix OCAMLPATH ':' ${ocamlpath}:$out/lib/)
  '';

  # Allow loading of external Frama-C plugins
  setupHook = writeText "setupHook.sh" ''
    addFramaCPath () {
      if test -d "''$1/lib/frama-c/plugins"; then
        export FRAMAC_PLUGIN="''${FRAMAC_PLUGIN-}''${FRAMAC_PLUGIN:+:}''$1/lib/frama-c/plugins"
        export OCAMLPATH="''${OCAMLPATH-}''${OCAMLPATH:+:}''$1/lib/frama-c/plugins"
      fi

      if test -d "''$1/lib/frama-c"; then
        export OCAMLPATH="''${OCAMLPATH-}''${OCAMLPATH:+:}''$1/lib/frama-c"
      fi

      if test -d "''$1/share/frama-c/"; then
        export FRAMAC_EXTRA_SHARE="''${FRAMAC_EXTRA_SHARE-}''${FRAMAC_EXTRA_SHARE:+:}''$1/share/frama-c"
      fi

    }

    addEnvHooks "$targetOffset" addFramaCPath
  '';


  meta = {
    description = "An extensible and collaborative platform dedicated to source-code analysis of C software";
    homepage    = "http://frama-c.com/";
    license     = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ thoughtpolice amiddelk ];
    platforms   = lib.platforms.unix;
  };
}
