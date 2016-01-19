{stdenv, fetchFromGitHub, buildRebar3, ibrowse, jsx, erlware_commons, getopt }:

buildRebar3 rec {
    name = "hex2nix";
    version = "0.0.3";

    src = fetchFromGitHub {
         owner = "erlang-nix";
         repo = "hex2nix";
         rev = "${version}";
         sha256 = "1snlcb60al7fz3z4c4rqrb9gqdyihyhsrr90n40v9rdm98csry3k";
     };

    erlangDeps = [ ibrowse jsx erlware_commons getopt ];

    DEBUG=1;

    installPhase = ''
      runHook preInstall
      make PREFIX=$out install
      runHook postInstall
    '';
 }
