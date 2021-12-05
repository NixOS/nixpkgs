{ lib, stdenv, fetchurl, unzip, makeWrapper, gawk, glibc }:

let
  version = "1.9.0";

  sources = let base = "https://releases.hashicorp.com/vault/${version}";
  in {
    x86_64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_amd64.zip";
      sha256 = "sha256-atiwnKcNXCgiyHG3vSDs3vto6dpMS5qmBiAAqb/xn3o=";
    };
    i686-linux = fetchurl {
      url = "${base}/vault_${version}_linux_386.zip";
      sha256 = "sha256-ZqsWWyaZ7b7RjR999mvHe+f68w3+x5xwPB+EXseYaKk=";
    };
    x86_64-darwin = fetchurl {
      url = "${base}/vault_${version}_darwin_amd64.zip";
      sha256 = "sha256-PXK72di2SNAgyAqu1SimZNN3YLqWwMw9E2cagpN3b4Y=";
    };
    aarch64-darwin = fetchurl {
      url = "${base}/vault_${version}_darwin_arm64.zip";
      sha256 = "sha256-7OxGz3jqzvfC/y2vkTdhQ+IjmMSQ4XmSHecbJ/oM2EI=";
    };
    aarch64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_arm64.zip";
      sha256 = "sha256-Yy7mdXXdEBl1u/KB95/bWaDdej9SSIOMQsk3KCEeR5s=";
    };
  };

in stdenv.mkDerivation {
  pname = "vault-bin";
  inherit version;

  src = sources.${stdenv.hostPlatform.system} or (throw
    "unsupported system: ${stdenv.hostPlatform.system}");

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

  dontStrip = stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://www.vaultproject.io";
    description = "A tool for managing secrets, this binary includes the UI";
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
    license = licenses.mpl20;
    maintainers = with maintainers;
      teams.serokell.members ++ [ offline psyanticy Chili-Man ];
  };
}
