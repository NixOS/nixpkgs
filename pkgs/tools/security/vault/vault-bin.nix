{ lib, stdenv, fetchurl, unzip }:

let
  version = "1.7.0";

  sources = let
    base = "https://releases.hashicorp.com/vault/${version}";
  in {
    x86_64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_amd64.zip";
      sha256 = "0d8wqxqilv1jdf4dl7w2jp3lfh0w0rawidmhjlj3ykpg6l3gblma";
    };
    i686-linux = fetchurl {
      url = "${base}/vault_${version}_linux_386.zip";
      sha256 = "128r0phm5i1cpayz0ia8qsmnk1ia3qylidy9f8iwk3l8r834s4yd";
    };
    x86_64-darwin = fetchurl {
      url = "${base}/vault_${version}_darwin_amd64.zip";
      sha256 = "01vxjv95his8jqin2cwcw691wdwn6p876rp021bmvr6diw6clkrp";
    };
    aarch64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_arm64.zip";
      sha256 = "0ahdv14fz7ybl11b61z7j13nbjd6hp6fcpc5bk6y8lh4qj8x0pzg";
    };
  };

in stdenv.mkDerivation {
  pname = "vault-bin";
  inherit version;

  src = sources.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/bash-completion/completions
    mv vault $out/bin
    echo "complete -C $out/bin/vault vault" > $out/share/bash-completion/completions/vault

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.vaultproject.io";
    description = "A tool for managing secrets, this binary includes the UI";
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" ];
    license = licenses.mpl20;
    maintainers = with maintainers; [ offline psyanticy mkaito Chili-Man ];
  };
}
