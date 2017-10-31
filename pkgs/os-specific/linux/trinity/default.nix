{ stdenv, fetchurl, fetchFromGitHub, linuxHeaders }:

stdenv.mkDerivation rec {
  name = "trinity-${version}";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "kernelslacker";
    repo = "trinity";
    rev = "v${version}";
    sha256 = "1jwgsjjbngn2dsnkflyigy3ajd0szksl30dlaiy02jc6mqi3nr0p";
  };

  patches = stdenv.lib.singleton (fetchurl {
    url = "https://github.com/kernelslacker/trinity/commit/b0e66a2d084ffc210bc1fc247efb4d177e9f7e3d.patch";
    sha256 = "0468fdzbsj3n3k43qm8hf56pa020qn57ripcykv9jfwp215lf0an";
  });

  postPatch = ''
    patchShebangs ./configure.sh
    patchShebangs ./scripts/
    substituteInPlace Makefile --replace '/usr/bin/wc' 'wc'
    substituteInPlace configure.sh --replace '/usr/include/linux' '${linuxHeaders}/include/linux'
  '';

  configurePhase = "./configure.sh";

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
