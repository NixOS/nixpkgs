{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "trinity-${version}";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "kernelslacker";
    repo = "trinity";
    rev = "v${version}";
    sha256 = "0diwkda6n7yw8plfanivncwangk2kv1acxv0kyk3ly5jhlajwc0s";
  };

  patchPhase = ''
    patchShebangs ./configure.sh
    patchShebangs ./scripts/
    substituteInPlace Makefile --replace '/usr/bin/wc' 'wc'
  '';

  configurePhase = "./configure.sh";

  installPhase = "make DESTDIR=$out install";

  meta = with stdenv.lib; {
    description = "A Linux System call fuzz tester";
    homepage = http://codemonkey.org.uk/projects/trinity/;
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
