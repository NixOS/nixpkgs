{ stdenv, fetchFromGitHub, buildRebar3, buildHex

, getopt_0_8_2, erlware_commons_1_0_0 }:

let
  ibrowse_4_4_0 = buildHex {
    name = "ibrowse";
    version = "4.4.0";
    sha256 = "1hpic1xgksfm00mbl1kwmszca6jmjca32s7gdd8g11i0hy45k3ka";
  };
  jsx_2_8_2 = buildHex {
    name = "jsx";
    version = "2.8.2";
    sha256 = "0k7lnmwqbgpmh90wy30kc0qlddkbh9r3sjlyayaqsz1r1cix7idl";
  };

in
buildRebar3 rec {
    name = "hex2nix";
    version = "0.0.6";

    src = fetchFromGitHub {
      owner = "erlang-nix";
      repo = "hex2nix";
      rev = "${version}";
      sha256 = "17rkzg836v7z2xf0i5m8zqfvr23dbmw1bi3c83km92f9glwa1dbf";
    };

    beamDeps = [ ibrowse_4_4_0 jsx_2_8_2 erlware_commons_1_0_0 getopt_0_8_2 ];

    enableDebugInfo = true;

    installPhase = ''
      runHook preInstall
      make PREFIX=$out install
      runHook postInstall
    '';
 }
