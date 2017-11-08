{ stdenv, fetchurl, fetchFromGitHub, linuxHeaders }:

stdenv.mkDerivation rec {
  name = "trinity-${version}";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "kernelslacker";
    repo = "trinity";
    rev = "v${version}";
    sha256 = "1ss6ir3ki2hnj4c8068v5bz8bpa43xqg9zlmzhgagi94g9l05qlf";
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
