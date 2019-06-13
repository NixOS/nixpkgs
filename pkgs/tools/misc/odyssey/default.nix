{ stdenv, fetchFromGitHub, cmake, openssl }:

stdenv.mkDerivation rec {
  pname = "odyssey";
  version = "unstable-2019-03-12";

  src = fetchFromGitHub {
    owner = "yandex";
    repo = pname;
    rev = "af015839b03f30260c75d8f565521910c0694ed6";
    sha256 = "1cnnypvk78wp1qmqfriky40ls0grkp4v46mypyaq5kl8ppknvnvs";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl ];

  installPhase = ''
    install -Dm755 -t $out/bin sources/odyssey
  '';

  meta = with stdenv.lib; {
    description = "Scalable PostgreSQL connection pooler";
    homepage = https://github.com/yandex/odyssey;
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
    platforms = [ "x86_64-linux" ];
  };
}
