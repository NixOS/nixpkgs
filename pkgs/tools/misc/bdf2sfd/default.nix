{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "bdf2sfd";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "fcambus";
    repo = pname;
    rev = version;
    sha256 = "sha256-q+FLmu2JCDTJ6zC8blkd27jAKWbNpPyKzmUj1bW1mfA=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "BDF to SFD converter";
    homepage = "https://github.com/fcambus/bdf2sfd";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
