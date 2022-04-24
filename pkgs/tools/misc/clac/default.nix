{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "clac";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "soveran";
    repo = "clac";
    rev = version;
    sha256 = "rsag8MWl/udwXC0Gj864fAuQ6ts1gzrN2N/zelazqjE=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    mkdir -p "$out/share/doc/${pname}"
    cp README* LICENSE "$out/share/doc/${pname}"
  '';

  meta = with lib; {
    description = "Interactive stack-based calculator";
    homepage = "https://github.com/soveran/clac";
    license = licenses.bsd2;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
