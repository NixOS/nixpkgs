{ stdenv, fetchFromGitHub, go }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "xurls-${version}";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "xurls";
    rev = "v${version}";
    sha256 = "05q4nqbpgfb0a35sn22rn9mlag2ks4cgwb54dx925hipp6zgj1hx";
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
    maintainers = with maintainers; [ koral ndowens ];
    platforms = platforms.unix;
  };
}
