{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "bdf2sfd";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "fcambus";
    repo = pname;
    rev = version;
    sha256 = "1fhdl739a4v8296wpn2390fhlb6vlg9m1zik7mql4l9008ncd5mv";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "BDF to SFD converter";
    homepage = "https://github.com/fcambus/bdf2sfd";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
