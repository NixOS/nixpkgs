{ lib, buildDunePackage, fetchurl, makeWrapper
, curly, fmt, bos, cmdliner, re, rresult, logs
, odoc, opam-format, opam-core, opam-state
, opam, git, findlib, mercurial, bzip2, gnutar, coreutils
, alcotest, mdx
}:

# don't include dune as runtime dep, so user can
# choose between dune and dune_2
let runtimeInputs = [ opam findlib git mercurial bzip2 gnutar coreutils ];
in buildDunePackage rec {
  pname = "dune-release";
  version = "1.3.3";

  minimumOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/ocamllabs/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "04qmgvjh1233ri878wi5kifdd1070w5pbfkd8yk3nnqnslz35zlb";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ curly fmt cmdliner re opam-format opam-state opam-core
                  rresult logs odoc bos ];
  checkInputs = [ alcotest mdx ];
  doCheck = true;

  useDune2 = true;

  # remove check for curl in PATH, since curly is patched
  # to have a fixed path to the binary in nix store
  postPatch = ''
    sed -i '/must_exist (Cmd\.v "curl"/d' lib/github.ml
  '';

  # tool specific env vars have been deprecated, use PATH
  preFixup = ''
    wrapProgram $out/bin/dune-release \
      --prefix PATH : "${lib.makeBinPath runtimeInputs}"
  '';

  meta = with lib; {
    description = "Release dune packages in opam";
    homepage = "https://github.com/ocamllabs/dune-release";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
