{ lib, stdenv
, fetchFromGitHub
, cmake
, mbedtls
, fuse
}:


stdenv.mkDerivation rec {
  pname = "dislocker";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "aorimn";
    repo = "dislocker";
    rev = "v${version}";
    sha256 = "1ak68s1v5dwh8y2dy5zjybmrh0pnqralmyqzis67y21m87g47h2k";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ fuse mbedtls ];

  meta = with lib; {
    description = "Read BitLocker encrypted partitions in Linux";
    homepage    = "https://github.com/aorimn/dislocker";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ elitak ];
    platforms   = platforms.linux;
  };
}
