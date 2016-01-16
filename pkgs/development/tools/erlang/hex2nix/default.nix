{stdenv, fetchFromGitHub, buildRebar3, ibrowse, jsx, erlware_commons, getopt }:

buildRebar3 rec {
    name = "hex2nix";
    version = "0.0.2";

    src = fetchFromGitHub {
         owner = "erlang-nix";
         repo = "hex2nix";
         rev = "${version}";
         sha256 = "18gkq5fkdiwq5zj98cz4kqxbpzjkpqcplpsw987drxwdbvq4hkwm";
     };

    erlangDeps = [ ibrowse jsx erlware_commons getopt ];

    DEBUG=1;

    installPhase = ''
      runHook preInstall
      make PREFIX=$out install
      runHook postInstall
    '';
 }
