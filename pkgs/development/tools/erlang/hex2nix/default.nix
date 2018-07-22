{ fetchFromGitHub, buildRebar3,

  # Erlang dependencies:
  ibrowse_4_2_2,
  getopt_0_8_2,
  erlware_commons_1_0_0,
  jsx_2_8_0 }:

buildRebar3 rec {
    name = "hex2nix";
    version = "0.0.6-a31eadd7";

    src = fetchFromGitHub {
      owner  = "erlang-nix";
      repo   = "hex2nix";
      rev    = "a31eadd7af2cbdac1b87991b378e98ea4fb40ae0";
      sha256 = "1hnkrksyrbpq2gq25rfsrnm86n0g3biab88gswm3zj88ddrz6dyk";
    };

    beamDeps = [ ibrowse_4_2_2 jsx_2_8_0 erlware_commons_1_0_0 getopt_0_8_2 ];

    enableDebugInfo = true;

    installPhase = ''
      runHook preInstall
      make PREFIX=$out install
      runHook postInstall
    '';
 }
