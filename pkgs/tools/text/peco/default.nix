{ stdenv, fetchFromGitHub, go, glide, git }:

stdenv.mkDerivation rec {
  name = "peco-${version}";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "peco";
    repo = "peco";
    rev = "v${version}";
    sha256 = "0jnlpr3nxx8xmjb6w4jlwshzz0p9hlww9919qbkm66afv16k0vm8";
  };

  nativeBuildInputs = [ go glide git ];

  buildPhase = ''
    mkdir -p src
    glide install
    mkdir -p ../src/github.com/peco
    (PECOSRC=$PWD && cd ../src/github.com/peco && ln -s $PECOSRC peco)
    GOPATH=$PWD/../ go build github.com/peco/peco/cmd/peco
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp peco $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Simplistic interactive filtering tool";
    homepage = https://github.com/peco/peco;
    license = licenses.mit;
    # peco should work on Windows or other POSIX platforms, but the go package
    # declares only linux and darwin.
    platforms = platforms.linux ++ platforms.darwin;
  };
}
