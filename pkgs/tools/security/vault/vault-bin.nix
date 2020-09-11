{ stdenv, fetchurl, unzip }:

let
  version = "1.5.3";

  sources = let
    base = "https://releases.hashicorp.com/vault/${version}";
  in {
    x86_64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_amd64.zip";
      sha256 = "1chhi7piq04j8rgk15rcszqqp37xd9cjj67plr5pgvdps3s1zihy";
    };
    i686-linux = fetchurl {
      url = "${base}/vault_${version}_linux_386.zip";
      sha256 = "0jbnvypapang025wfyj6i70jdz3g29ggg7rzmg8xh6gfyhwk3vmb";
    };
    x86_64-darwin = fetchurl {
      url = "${base}/vault_${version}_darwin_amd64.zip";
      sha256 = "1m54258lfdr79p2j8janbkhp0a8bs8xbrcr51lqx2s620n7sfbya";
    };
    i686-darwin = fetchurl {
      url = "${base}/vault_${version}_darwin_386.zip";
      sha256 = "038qkkhlwj86fz9vpcycvv5nb41y8mqypqvhfp0ia11birp8xlsr";
    };
    aarch64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_arm64.zip";
      sha256 = "1vivkwcy9j9zs7w65k7y8chix8jnii5pz8zck6rlpwgz5vs0h04k";
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
    homepage = "https://www.vaultproject.io";
    description = "A tool for managing secrets, this binary includes the UI";
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "i686-darwin" ];
    license = licenses.mpl20;
    maintainers = with maintainers; [ offline psyanticy mkaito ];
  };
}
