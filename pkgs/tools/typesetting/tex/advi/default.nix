{ fetchurl
, lib
, makeWrapper
, writeShellScriptBin
, ghostscriptX
, ocamlPackages
, texliveMedium
, which
}:

let
  # simplified fake-opam edited from tweag's opam-nix
  fake-opam = writeShellScriptBin "opam" ''
    case "$1 $2" in
      "config var")
        case "$3" in
          man) echo "$out/share/man";;
          etc) echo "$out/etc";;
          doc) echo "$out/share/doc";;
          share) echo "$out/share";;
          prefix) echo "$out";;
          *) echo "fake-opam does not understand arguments: $@" ; exit 1 ;;
        esac;;
      *) echo "fake-opam does not understand arguments: $@" ; exit 1 ;;
    esac
  '';

  # texlive currently does not symlink kpsexpand
  kpsexpand = writeShellScriptBin "kpsexpand" ''
    exec kpsetool -v
  '';
in
ocamlPackages.buildDunePackage rec {
  pname = "advi";
  version = "2.0.0";

  minimalOCamlVersion = "4.11";

  src = fetchurl {
    url = "http://advi.inria.fr/advi-${version}.tar.gz";
    hash = "sha256-c0DQHlvdekJyXCxmR4+Ut/njtoCzmqX6hNazNv8PpBQ=";
  };

  postPatch = ''
    substituteInPlace ./Makefile \
      --replace "\$(DUNE) install \$(DUNEROOT) --display=short" \
      "\$(DUNE) install \$(DUNEROOT) --prefix $out --docdir $out/share/doc --mandir $out/share/man"
    substituteInPlace ./src/discover.sh \
      --replace 'gs_path=$(which gs)' 'gs_path=${ghostscriptX}/bin/gs'
  '';

  duneVersion = "3";

  nativeBuildInputs = [ fake-opam kpsexpand makeWrapper texliveMedium which ];
  buildInputs = with ocamlPackages; [ camlimages ghostscriptX graphics ];

  # install additional files (such as man pages)
  preInstall = ''
    make install
  '';

  # TODO: redirect /share/advi/tex/latex to tex output compatible with texlive.combine
  # (requires patching check() in advi-latex-files)

  meta = with lib; {
    homepage = "http://advi.inria.fr/";
    description = "Active-DVI is a Unix-platform DVI previewer and a programmable presenter for slides written in LaTeX.";
    license = licenses.lgpl21Only;
    maintainers = [ maintainers.xworld21 ];
  };
}
