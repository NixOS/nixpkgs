{ fetchurl
, lib
, makeWrapper
, writeShellScriptBin
, ghostscriptX
, ocamlPackages
, texlive
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
  '';

  duneVersion = "3";

  nativeBuildInputs = [ fake-opam kpsexpand makeWrapper texlive.combined.scheme-medium which ];
  buildInputs = with ocamlPackages; [ camlimages ghostscriptX graphics ];

  # TODO: ghostscript linked from texlive.combine will override ghostscriptX and break advi
  preInstall = ''
    make install
    wrapProgram "$out/bin/advi" --prefix PATH : "${lib.makeBinPath [ ghostscriptX ]}"
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
