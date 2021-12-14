{ lib, stdenv, fetchurl, unzip, makeWrapper, gawk, glibc }:

let
  version = "1.9.1";

  sources = let
    base = "https://releases.hashicorp.com/vault/${version}";
  in {
    x86_64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_amd64.zip";
      sha256 = "sha256-kP1wLbkktVCTZopVaT0h/WKqAG3Pd9g7qeruk4MIWJM=";
    };
    i686-linux = fetchurl {
      url = "${base}/vault_${version}_linux_386.zip";
      sha256 = "sha256-cTZ/hek8wQo9FxIRQ/cc23h7Nqjfonvprf492/lSzLw=";
    };
    x86_64-darwin = fetchurl {
      url = "${base}/vault_${version}_darwin_amd64.zip";
      sha256 = "sha256-uKW9Yl4PjxWJ886OVAHl1sbPhgYWoL6IJK44vczLQsY=";
    };
    aarch64-darwin = fetchurl {
      url = "${base}/vault_${version}_darwin_arm64.zip";
      sha256 = "sha256-J0qwUBcnZRZU5TTQB3K8wNE6rdQC1Boy/gKNQRvUYEI=";
    };
    aarch64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_arm64.zip";
      sha256 = "sha256-eU5s15tBuZFThJGNtnjOV07tiBoVjSSHMS9sY2WqO1o=";
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

  dontStrip = stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://www.vaultproject.io";
    description = "A tool for managing secrets, this binary includes the UI";
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ];
    license = licenses.mpl20;
    maintainers = with maintainers; teams.serokell.members ++ [ offline psyanticy Chili-Man ];
  };
}
