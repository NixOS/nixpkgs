{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "trinity";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "kernelslacker";
    repo = "trinity";
    rev = "v${version}";
    sha256 = "0z1a7x727xacam74jccd223k303sllgwpq30lnq9b6xxy8b659bv";
  };

  postPatch = ''
    patchShebangs configure
    patchShebangs scripts
  '';

  enableParallelBuilding = true;

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "A Linux System call fuzz tester";
    homepage = "https://codemonkey.org.uk/projects/trinity/";
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
