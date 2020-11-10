{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "bdf2sfd";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "fcambus";
    repo = pname;
    rev = version;
    sha256 = "1bpadw25barzmmsz9bkrsj3iwbgf945zqfakbgq1yscfb85bfgsp";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "BDF to SFD converter";
    homepage = "https://github.com/fcambus/bdf2sfd";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
