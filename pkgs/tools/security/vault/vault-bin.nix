{ lib, stdenv, fetchurl, unzip, makeWrapper, gawk, glibc }:

let
  version = "1.8.1";

  sources = let
    base = "https://releases.hashicorp.com/vault/${version}";
  in {
    x86_64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_amd64.zip";
      sha256 = "sha256-u0EfK7rXnC5PBkDx09XvUOK9p9T0CHWlaRfJX/eDwts=";
    };
    i686-linux = fetchurl {
      url = "${base}/vault_${version}_linux_386.zip";
      sha256 = "11khjx5lrb7zmrahkniqwn4ad98yjy2fm0miz63nzpq85c0yrjdn";
    };
    x86_64-darwin = fetchurl {
      url = "${base}/vault_${version}_darwin_amd64.zip";
      sha256 = "02gqavhg3pk6jkdmn1yp9pl3pv4ni2sg56q218gs8gbbypj22wpq";
    };
    aarch64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_arm64.zip";
      sha256 = "0500nc8v7hwnrckz4fkf5fpqcg3i45q25lz4lghzkcabnss4qand";
    };
  };

in stdenv.mkDerivation {
  pname = "vault-bin";
  inherit version;

  src = sources.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ makeWrapper unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/bash-completion/completions
    mv vault $out/bin
    echo "complete -C $out/bin/vault vault" > $out/share/bash-completion/completions/vault
  '' + lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/vault \
      --prefix PATH : ${lib.makeBinPath [ gawk glibc ]}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.vaultproject.io";
    description = "A tool for managing secrets, this binary includes the UI";
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" ];
    license = licenses.mpl20;
    maintainers = with maintainers; teams.serokell.members ++ [ offline psyanticy Chili-Man ];
  };
}
