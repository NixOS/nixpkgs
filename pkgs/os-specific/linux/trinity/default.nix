{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "trinity";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "kernelslacker";
    repo = "trinity";
    rev = "v${version}";
    sha256 = "0z1a7x727xacam74jccd223k303sllgwpq30lnq9b6xxy8b659bv";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchains
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/kernelslacker/trinity/commit/e53e25cc8dd5bdb5f7d9b4247de9e9921eec81d8.patch";
      sha256 = "0dbhyc98x11cmac6rj692zymnfqfqcbawlrkg1lhgfagzjxxwshg";
    })
  ];

  postPatch = ''
    patchShebangs configure
    patchShebangs scripts
  '';

  enableParallelBuilding = true;

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "A Linux System call fuzz tester";
    homepage = "https://codemonkey.org.uk/projects/trinity/";
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
