{ lib, stdenv, fetchurl, unzip, makeWrapper, gawk, glibc }:

let
  version = "1.8.4";

  sources = let
    base = "https://releases.hashicorp.com/vault/${version}";
  in {
    x86_64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_amd64.zip";
      sha256 = "sha256-zrCRnIScIWJ8ocrgYPNhtvuX3PBLF9HX0dyZU/zY4yk=";
    };
    i686-linux = fetchurl {
      url = "${base}/vault_${version}_linux_386.zip";
      sha256 = "0sh9q29b0bi5ap6nvll0ykxd5vf4wliksj31cmm4gw5vp90irvl3";
    };
    x86_64-darwin = fetchurl {
      url = "${base}/vault_${version}_darwin_amd64.zip";
      sha256 = "09nhfdw20g46fnrn82my7a59pfa81dxncxhiswmha3cdy8n0p6wb";
    };
    aarch64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_arm64.zip";
      sha256 = "01ra0xrgivf01ff87p0gqmi1flnac9y02x7jpv5j6a9czr1sqw1j";
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
