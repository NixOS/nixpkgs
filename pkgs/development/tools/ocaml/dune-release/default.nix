{ lib, buildDunePackage, fetchurl, makeWrapper, fetchpatch
, curly, fmt, bos, cmdliner, re, rresult, logs, fpath
, odoc, opam-format, opam-core, opam-state, yojson, astring
, opam, git, findlib, mercurial, bzip2, gnutar, coreutils
, alcotest
}:

# don't include dune as runtime dep, so user can
# choose between dune and dune_2
let runtimeInputs = [ opam findlib git mercurial bzip2 gnutar coreutils ];
in buildDunePackage rec {
  pname = "dune-release";
  version = "1.5.2";

  minimumOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/ocamllabs/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "1r6bz1zz1al5y762ws3w98d8bnyi5ipffajgczixacmbrxvp3zgx";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ curly fmt cmdliner re opam-format opam-state opam-core
                  rresult logs odoc bos yojson astring fpath ];
  checkInputs = [ alcotest ] ++ runtimeInputs;
  doCheck = true;

  useDune2 = true;

  patches = [
    # add missing git config calls to avoid failing due to the lack of a global git config
    (fetchpatch {
      name = "tests-missing-git-config.patch";
      url = "https://github.com/ocamllabs/dune-release/commit/87e7ffe2a9c574620d4e2fc0d79eed8772eab973.patch";
      sha256 = "0wrzcpzr54dwrdjdc75mijh78xk4bmsmqs1pci06fb2nf03vbd2k";
    })
  ];

  postPatch = ''
    # remove check for curl in PATH, since curly is patched
    # to have a fixed path to the binary in nix store
    sed -i '/must_exist (Cmd\.v "curl"/d' lib/github.ml
  '';

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
