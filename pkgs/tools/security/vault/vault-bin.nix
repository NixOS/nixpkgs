{ stdenv, fetchurl, unzip }:

let
  version = "1.1.3";

  sources = let
    base = "https://releases.hashicorp.com/vault/${version}";
  in {
    "x86_64-linux" = fetchurl {
      url = "${base}/vault_${version}_linux_amd64.zip";
      sha256 = "293b88f4d31f6bcdcc8b508eccb7b856a0423270adebfa0f52f04144c5a22ae0";
    };
    "i686-linux" = fetchurl {
      url = "${base}/vault_${version}_linux_386.zip";
      sha256 = "9f2fb99e08fa3d25af1497516d08b5d2d8a73bcacd5354ddec024e9628795867";
    };
    "x86_64-darwin" = fetchurl {
      url = "${base}/vault_${version}_darwin_amd64.zip";
      sha256 = "a0a7a242f8299ac4a00af8aa10ccedaf63013c8a068f56eadfb9d730b87155ea";
    };
    "i686-darwin" = fetchurl {
      url = "${base}/vault_${version}_darwin_386.zip";
      sha256 = "50542cfb37abb06e8bb6b8ba41f5ca7d72a4d6a4396d4e3f4a8391bed14f63be";
    };
    "aarch64-linux" = fetchurl {
      url = "${base}/vault_${version}_linux_arm64.zip";
      sha256 = "c243dce14b2e48e3667c2aa5b7fb37009dd7043b56032d6ebe50dd456715fd3f";
    };
  };

in stdenv.mkDerivation {
  pname = "vault-bin";
  inherit version;

  src = sources."${stdenv.hostPlatform.system}" or (throw "unsupported system: ${stdenv.hostPlatform.system}");

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
    maintainers = with maintainers; [ offline psyanticy ];
  };
}
