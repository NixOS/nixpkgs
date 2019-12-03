{ stdenv, fetchurl, unzip }:

let
  version = "1.3.0";

  sources = let
    base = "https://releases.hashicorp.com/vault/${version}";
  in {
    x86_64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_amd64.zip";
      sha256 = "1crfj4gd1qwwa2xidd0pjffv0n6hf5hbhv6568m6zc1ig0qqm6yq";
    };
    i686-linux = fetchurl {
      url = "${base}/vault_${version}_linux_386.zip";
      sha256 = "0pyf0kyvxpmx3fwfvin1r0x30r9byx9lyi81894q06xrhiwbqc0l";
    };
    x86_64-darwin = fetchurl {
      url = "${base}/vault_${version}_darwin_amd64.zip";
      sha256 = "113vnpz9n6y7z2k9jqpfpxqxqbrmd9bhny79yaxqzkfdqw8vyv3g";
    };
    i686-darwin = fetchurl {
      url = "${base}/vault_${version}_darwin_386.zip";
      sha256 = "0d191qai0bpl7cyivca26wqgycsj2dz08809z147d1vnrz321v6w";
    };
    aarch64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_arm64.zip";
      sha256 = "1bk5y3knc42mh07gnnn6p109qz908014620h1s0348wp4qfdy49w";
    };
  };

in stdenv.mkDerivation {
  pname = "vault-bin";
  inherit version;

  src = sources.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin $out/share/bash-completion/completions
    mv vault $out/bin
    echo "complete -C $out/bin/vault vault" > $out/share/bash-completion/completions/vault
  '';

  meta = with stdenv.lib; {
    homepage = https://www.vaultproject.io;
    description = "A tool for managing secrets, this binary includes the UI";
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "i686-darwin" ];
    license = licenses.mpl20;
    maintainers = with maintainers; [ offline psyanticy mkaito ];
  };
}
