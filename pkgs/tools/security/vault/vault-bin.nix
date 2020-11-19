{ stdenv, fetchurl, unzip, nixosTests }:

let
  version = "1.5.5";

  sources = let
    base = "https://releases.hashicorp.com/vault/${version}";
  in {
    x86_64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_amd64.zip";
      sha256 = "1vg1c34d2ck2a96p800gblq06jakg29yzrczaa6nsmnnr3k5hs9a";
    };
    i686-linux = fetchurl {
      url = "${base}/vault_${version}_linux_386.zip";
      sha256 = "1hf46mm7shvq9gpi50b6hcp2cydhzbkwigqcnl527y4cvc9iv7in";
    };
    x86_64-darwin = fetchurl {
      url = "${base}/vault_${version}_darwin_amd64.zip";
      sha256 = "1jna9rmdhqi7j8p67y9dzq716dv8fn4rjsn76mbvlgc5wylky6gz";
    };
    i686-darwin = fetchurl {
      url = "${base}/vault_${version}_darwin_386.zip";
      sha256 = "1qv02zd5dwaw1i52pnbyshbd8cy0x5nr3f2s9l3p9ci5rzad4rjn";
    };
    aarch64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_arm64.zip";
      sha256 = "1y4i62qq5cx2bv18dnbgys2qa5xx0acn8j3hdh0dbsw0zyms4qv7";
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

  passthru.tests.vault = nixosTests.vault;

  meta = with stdenv.lib; {
    homepage = "https://www.vaultproject.io";
    description = "A tool for managing secrets, this binary includes the UI";
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "i686-darwin" ];
    license = licenses.mpl20;
    maintainers = with maintainers; [ offline psyanticy mkaito ];
  };
}
