{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "redo-c";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = pname;
    rev = "v${version}";
    sha256 = "11wc2sgw1ssdm83cjdc6ndnp1bv5mzhbw7njw47mk7ri1ic1x51b";
  };

  postPatch = ''
    cp '${./Makefile}' Makefile
  '';

  meta = with stdenv.lib; {
    description = "An implementation of the redo build system in portable C with zero dependencies";
    homepage = "https://github.com/leahneukirchen/redo-c";
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = with maintainers; [ ck3d ];
  };
}
