{ stdenv, fetchFromGitHub, go }:

stdenv.mkDerivation rec {
  version = "0.7.0";
  name = "xurls-${version}";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "xurls";
    rev = "v${version}";
    sha256 = "1sdxz1vqm9kidva7lilway69n4fdkqa4kdldx47jriq2hr96s7n0";
  };

  buildInputs = [ go ];

  buildPhase = ''
    mkdir -p src/github.com/mvdan
    ln -s $(pwd) src/github.com/mvdan/xurls
    export GOPATH=$(pwd)
    cd cmd/xurls
    go build -v
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv xurls $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Extract urls from text";
    homepage = https://github.com/mvdan/xurls;
    maintainers = [ maintainers.koral ];
  };
}
