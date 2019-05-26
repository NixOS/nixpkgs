{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.1";
  pname = "qgrep";

  src = fetchFromGitHub {
    owner = "zeux";
    repo = "qgrep";
    rev = "v${version}";
    sha256 = "046ccw34vz2k5jn6gyxign5gs2qi7i50jy9b74wqv7sjf5zayrh0";
    fetchSubmodules = true;
  };

  installPhase = '' 
    install -Dm755 qgrep $out/bin/qgrep
  '';

  meta = with stdenv.lib; {
    description = "Fast regular expression grep for source code with incremental index updates";
    homepage = https://github.com/zeux/qgrep;
    license = licenses.mit;
    maintainers = [ maintainers.yrashk ];
    platforms = platforms.all;
  };

}
