{ lib, buildDunePackage, fetchurl, makeWrapper, fetchpatch
, curly, fmt, bos, cmdliner_1_1, re, rresult, logs, fpath
, odoc, opam-format, opam-core, opam-state, yojson, astring
, opam, git, findlib, mercurial, bzip2, gnutar, coreutils
, alcotest
}:

# don't include dune as runtime dep, so user can
# choose between dune and dune_2
let runtimeInputs = [ opam findlib git mercurial bzip2 gnutar coreutils ];
in buildDunePackage rec {
  pname = "dune-release";
  version = "1.6.2";

  minimumOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/ocamllabs/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "03i01my7nv13h782x8s8cfd9hgvdwdsglssal2rrhcwdp8pm57m0";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ curly fmt cmdliner_1_1 re opam-format opam-state opam-core
                  rresult logs odoc bos yojson astring fpath ];
  checkInputs = [ alcotest ] ++ runtimeInputs;
  doCheck = true;

  useDune2 = true;

  preCheck = ''
    # it fails when it tries to reference "./make_check_deterministic.exe"
    rm -r tests/bin/check
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
