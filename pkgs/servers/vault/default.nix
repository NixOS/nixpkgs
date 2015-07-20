{ stdenv, fetchgit, go, gox }:

let
  name = "vault";
  version = "0.1.2";
  namespace = "github.com/hashicorp/vault";
in
stdenv.mkDerivation rec {
  name = "vault-${version}";
  rev = "v${version}";

  src = fetchgit {
    url = "https://github.com/hashicorp/vault";
    sha256 = "a4267105dab56c6d0571f69ea0abc167c5debd3b6c0795b8b69e15a285e12f01";
    rev = "refs/tags/${rev}";
  };

  buildInputs = [ go gox ];

  buildPhase = ''
    mkdir -p "$(dirname Godeps/_workspace/src/${namespace})"
    ln -sf $src "Godeps/_workspace/src/${namespace}"
    export GOPATH=$PWD/Godeps/_workspace
    XC_OS=$(go env GOOS)
    XC_ARCH=$(go env GOARCH)
    mkdir -p bin/
    gox \
      -os "$XC_OS" \
      -arch "$XC_ARCH" \
      -ldflags "-X github.com/hashicorp/vault/cli.GitCommit ${rev}" \
      -output $PWD/bin/vault \
      -verbose \
      .
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/vault $out/bin/vault
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.vaultproject.io";
    description = "A tool for securely accessing secrets";
    maintainers = with maintainers; [ avnik ];
    license     = licenses.mit ;
    platforms   = platforms.all;
  };
}
