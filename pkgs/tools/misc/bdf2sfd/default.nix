{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "bdf2sfd";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "fcambus";
    repo = pname;
    rev = version;
    sha256 = "0v1kkds35qfyv1h5kxc2m7f2gsprg9c7jzpsm3p4f71qn982wry6";
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
