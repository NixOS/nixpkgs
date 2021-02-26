{ lib, stdenv, fetchurl, unzip }:

let
  version = "1.6.3";

  sources = let
    base = "https://releases.hashicorp.com/vault/${version}";
  in {
    x86_64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_amd64.zip";
      sha256 = "0ijc80r9rbbbblmf5s3j5b2kk6zsriyxwhsijhgy86rr6bvdljl4";
    };
    i686-linux = fetchurl {
      url = "${base}/vault_${version}_linux_386.zip";
      sha256 = "1blma0ywkmv8ykqc4sgcbk1g9jb9rjxqk2b6kmp5z31lilg4a7my";
    };
    x86_64-darwin = fetchurl {
      url = "${base}/vault_${version}_darwin_amd64.zip";
      sha256 = "1mzkj7ixpzfhn9i4092qw8g38dx4lh3kzp6g4fr5x84sbs6anl3j";
    };
    aarch64-linux = fetchurl {
      url = "${base}/vault_${version}_linux_arm64.zip";
      sha256 = "14l8ic5hgsbq4q1b6832ss1wyrgqwyvgkrvcxbw5nqy5la95fl8i";
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

  meta = with lib; {
    homepage = "https://www.vaultproject.io";
    description = "A tool for managing secrets, this binary includes the UI";
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" ];
    license = licenses.mpl20;
    maintainers = with maintainers; [ offline psyanticy mkaito Chili-Man ];
  };
}
