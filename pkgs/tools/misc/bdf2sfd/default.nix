{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "bdf2sfd";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "fcambus";
    repo = pname;
    rev = version;
    sha256 = "130kaw2485qhb2171w2i9kpl1lhbkfwdz3j19cy63xk63fhyd8kb";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "BDF to SFD converter";
    homepage = "https://github.com/fcambus/bdf2sfd";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
