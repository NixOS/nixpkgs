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
<<<<<<< HEAD
  version = "2.0.0";
=======
  version = "1.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  duneVersion = "3";

  minimalOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/ocamllabs/${pname}/releases/download/${version}/${pname}-${version}.tbz";
<<<<<<< HEAD
    hash = "sha256-u8TgaoeDaDLenu3s1Km/Kh85WHMtvUy7C7Q+OY588Ss=";
=======
    sha256 = "sha256-oJ5SL7qNM5izoEpr+nTjbT+YmmNIoy7QgSNse3wNIA4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper ] ++ runtimeInputs;
  buildInputs = [ curly fmt cmdliner re opam-format opam-state opam-core
                  rresult logs odoc bos yojson astring fpath ];
  nativeCheckInputs = [ odoc ];
  checkInputs = [ alcotest ] ++ runtimeInputs;
  doCheck = true;

  postPatch = ''
    # remove check for curl in PATH, since curly is patched
    # to have a fixed path to the binary in nix store
    sed -i '/must_exist (Cmd\.v "curl"/d' lib/github.ml
  '';

  preCheck = ''
<<<<<<< HEAD
    export HOME=$TMPDIR
    git config --global user.email "nix-builder@nixos.org"
    git config --global user.name "Nix Builder"

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/tarides/dune-release/blob/${version}/CHANGES.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
