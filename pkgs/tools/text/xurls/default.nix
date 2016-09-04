{ stdenv, fetchFromGitHub, go }:

stdenv.mkDerivation rec {
  version = "0.8.0";
  name = "xurls-${version}";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "xurls";
    rev = "v${version}";
    sha256 = "0j35x6hl5hiwzpi6vjw9d2sn83rrsd9w07ql9kndhkngz8n6yr98";
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
    platforms = platforms.unix;
  };
}
