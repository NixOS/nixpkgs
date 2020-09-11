{ stdenv, fetchFromGitHub, curl, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "hcxtools";
  version = "6.0.3";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = pname;
    rev = version;
    sha256 = "0s9l5mvzcv6hnj7h28piabnm66b09hk2l57vb85ny35w99hzpkc0";
  };

  buildInputs = [ curl openssl zlib ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with stdenv.lib; {
    description = "Tools for capturing wlan traffic and conversion to hashcat and John the Ripper formats";
    homepage = "https://github.com/ZerBea/hcxtools";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dywedir ];
  };
}
