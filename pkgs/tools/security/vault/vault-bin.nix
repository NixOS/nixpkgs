{ stdenv, fetchurl, unzip }:

let
  version = "1.5.4";

  sources = let
    base = "https://releases.hashicorp.com/vault/${version}";
  in {
    x86_64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_amd64.zip";
      sha256 = "1cyk9v70w0px2sxg8dichqgk38br9hc4kdl37jk57ci5gdl6w5ah";
    };
    i686-linux = fetchurl {
      url = "${base}/vault_${version}_linux_386.zip";
      sha256 = "1n6hmhd4g2c6zzbimslxpghma5dyqwb96w60srbf9gn2vrimg4l4";
    };
    x86_64-darwin = fetchurl {
      url = "${base}/vault_${version}_darwin_amd64.zip";
      sha256 = "05d5m8kdwl6mcx3swkasm5zcmddlyl6m9lwj26vbg9pllx9zxvqm";
    };
    i686-darwin = fetchurl {
      url = "${base}/vault_${version}_darwin_386.zip";
      sha256 = "109hisdwd58za541qhw61bscfrh3szzfn8vdmr4c7nh5praiqznb";
    };
    aarch64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_arm64.zip";
      sha256 = "0q8icl5ncvixrdmsd2ilzvpa6c1pswa6zgh3vccsj7sg8mxprjmr";
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
