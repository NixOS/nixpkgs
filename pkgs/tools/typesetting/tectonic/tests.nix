# This package provides `tectonic.passthru.tests`.
# It requires internet access to fetch tectonic's resource bundle on demand.

{
  lib,
  fetchFromGitHub,
  writeText,
  runCommand,
  tectonic,
  curl,
  cacert,
  emptyFile,
}:

let
  /*
    Currently, the test files are only fully available from the `dev` branch of
    `biber`. When https://github.com/plk/biber/pull/467 is eventually released,
    we can obtain the test files from `texlive.pkgs.biber.texsource`. For now,
    i.e. biber<=2.19, we fetch the test files directly from GitHub.
  */
  biber-dev-source = fetchFromGitHub {
    owner = "plk";
    repo = "biber";
    # curl https://api.github.com/repos/plk/biber/pulls/467 | jq .merge_commit_sha
    rev = "d43e352586f5c9f98f0331978ca9d0b908986e09";
    hash = "sha256-Z5BdMteBouiDQasF6GZXkS//YzrZkcX1eLvKIQIBkBs=";
  };
  testfiles = "${biber-dev-source}/testfiles";

  noNetNotice = writeText "tectonic-offline-notice" ''
    # To fetch tectonic's web bundle, the tests require internet access,
    # which is not available in the current environment.
  '';
  # `cacert` is required for tls connections
  nativeBuildInputs = [
    curl
    cacert
    tectonic
  ];
  checkInternet = ''
    if curl --head "bing.com"; then
      set -e # continue to the tests defined below, fail on error
    else
      cat "${noNetNotice}"
      cp "${emptyFile}" "$out"
      exit # bail out gracefully when there is no internet, do not panic
    fi
  '';

  networkRequiringTestPkg =
    name: script:
    runCommand
      /*
        Introduce dependence on `tectonic` in the test package name. Note that
        adding `tectonic` to `nativeBuildInputs` is not enough to trigger
        rebuilds for a fixed-output derivation. One must update its name or
        output hash to induce a rebuild. This behavior is exactly the same as a
        standard nixpkgs "fetcher" such as `fetchurl`.
      */
      "test-${lib.removePrefix "${builtins.storeDir}/" tectonic.outPath}-${name}"
      {
        /*
          Make a fixed-output derivation, return an `emptyFile` with fixed hash.
          These derivations are allowed to access the internet from within a
          sandbox, which allows us to test the automatic download of resource
          files in tectonic, as a side effect. The `tectonic.outPath` is included
          in `name` to induce rebuild of this fixed-output derivation whenever
          the `tectonic` derivation is updated.
        */
        inherit (emptyFile)
          outputHashAlgo
          outputHashMode
          outputHash
          ;
        allowSubstitutes = false;
        inherit nativeBuildInputs;
      }
      ''
        ${checkInternet}
        ${script}
        cp "${emptyFile}" "$out"
      '';

in
lib.mapAttrs networkRequiringTestPkg {
  biber-compatibility = ''
    # import the test files
    cp "${testfiles}"/* .

    # tectonic caches in the $HOME directory, so set it to $PWD
    export HOME=$PWD
    tectonic -X compile ./test.tex
  '';

  workspace = ''
    tectonic -X new
    cat Tectonic.toml | grep "${tectonic.bundleUrl}"
  '';

  /**
    test that the `nextonic -> tectonic` symlink is working as intended
  */
  nextonic = ''
    nextonic new 2>&1 \
      | grep '"version 2" Tectonic command-line interface activated'
  '';
}
