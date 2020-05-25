{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "bdf2sfd";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "fcambus";
    repo = pname;
    rev = version;
    sha256 = "02dzvrgwpgbd0wgfnlpiv2qlwvspwl7a0qh8cg363lpnxv8akw9q";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "BDF to SFD converter";
    homepage = "https://github.com/fcambus/bdf2sfd";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
