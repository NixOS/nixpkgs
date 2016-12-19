{stdenv, fetchFromGitHub, buildRebar3, ibrowse, jsx, erlware_commons, getopt }:

buildRebar3 rec {
    name = "hex2nix";
    version = "0.0.5";

    src = fetchFromGitHub {
      owner = "erlang-nix";
      repo = "hex2nix";
      rev = "${version}";
      sha256 = "07bk18nib4xms8q1i4sv53drvlyllm47map4c95669lsh0j08sax";
    };

    beamDeps = [ ibrowse jsx erlware_commons getopt ];

    DEBUG=1;

    installPhase = ''
      runHook preInstall
      make PREFIX=$out install
      runHook postInstall
    '';
 }
