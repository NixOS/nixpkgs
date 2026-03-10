{
  lib,
  buildDunePackage,
  fetchurl,
  makeWrapper,
  curly,
  fmt,
  bos,
  cmdliner,
  re,
  rresult,
  logs,
  fpath,
  odoc,
  opam-format,
  opam-core,
  opam-state,
  yojson,
  astring,
  opam,
  gitMinimal,
  findlib,
  mercurial,
  bzip2,
  gnutar,
  coreutils,
  alcotest,
}:

# don't include dune as runtime dep, so user can
# choose between dune and dune_2
let
  runtimeInputs = [
    opam
    findlib
    gitMinimal
    mercurial
    bzip2
    gnutar
    coreutils
  ];
in
buildDunePackage (finalAttrs: {
  pname = "dune-release";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/ocamllabs/dune-release/releases/download/${finalAttrs.version}/dune-release-${finalAttrs.version}.tbz";
    hash = "sha256-VxwXtG+n1TeVFp4CsAWmG7X3unbIAK09konm+KTW8G4=";
  };

  nativeBuildInputs = [ makeWrapper ] ++ runtimeInputs;
  buildInputs = [
    curly
    fmt
    cmdliner
    re
    opam-format
    opam-state
    opam-core
    rresult
    logs
    odoc
    bos
    yojson
    astring
    fpath
  ];
  nativeCheckInputs = [
    odoc
    gitMinimal
  ];
  checkInputs = [ alcotest ] ++ runtimeInputs;
  doCheck = true;

  postPatch = ''
    # remove check for curl in PATH, since curly is patched
    # to have a fixed path to the binary in nix store
    sed -i '/must_exist (Cmd\.v "curl"/d' lib/github.ml
  '';

  preCheck = ''
    export HOME=$TMPDIR
    git config --global user.email "nix-builder@nixos.org"
    git config --global user.name "Nix Builder"

    # it fails when it tries to reference "./make_check_deterministic.exe"
    rm -r tests/bin/check
  '';

  # tool specific env vars have been deprecated, use PATH
  preFixup = ''
    wrapProgram $out/bin/dune-release \
      --prefix PATH : "${lib.makeBinPath runtimeInputs}"
  '';

  meta = {
    description = "Release dune packages in opam";
    mainProgram = "dune-release";
    homepage = "https://github.com/ocamllabs/dune-release";
    changelog = "https://github.com/tarides/dune-release/blob/${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
})
