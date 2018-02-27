{ stdenv, fetchurl, fetchFromGitHub, linuxHeaders }:

stdenv.mkDerivation rec {
  name = "trinity-${version}";
  version = "1.8-git-2017-02-13";

  src = fetchFromGitHub {
    owner = "kernelslacker";
    repo = "trinity";
    rev = "2989c11ce77bc7bec23da62987e2c3a0dd8a83c9";
    sha256 = "19asyrypjhx2cgjdmwfvmgc0hk3xg00zvgkl89vwxngdb40bkwfq";
  };

  postPatch = ''
    patchShebangs ./configure
    patchShebangs ./scripts/
  '';

  enableParallelBuilding = true;

  installPhase = "make DESTDIR=$out install";

  meta = with stdenv.lib; {
    description = "A Linux System call fuzz tester";
    homepage = http://codemonkey.org.uk/projects/trinity/;
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
