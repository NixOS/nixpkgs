{ stdenv, fetchFromGitHub, curl, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "hcxtools";
  version = "5.1.4";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = pname;
    rev = version;
    sha256 = "1bkl0j6m5q091fas99s83aclcc5kfwacmkgmyg8565z2npvnj7nf";
  };

  buildInputs = [ curl openssl zlib ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with stdenv.lib; {
    description = "Tools for capturing wlan traffic and conversion to hashcat and John the Ripper formats";
    homepage = https://github.com/ZerBea/hcxtools;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dywedir ];
  };
}
