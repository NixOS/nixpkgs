{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "trinity-${version}";
  version = "1.8-git-2018-06-08";

  src = fetchFromGitHub {
    owner = "kernelslacker";
    repo = "trinity";
    rev = "1b2d43cb383cef86a05acb2df046ce5e9b17a7fe";
    sha256 = "0dsq10vmd6ii1dnpaqhizk9p8mbd6mwgpmi13b11dxwxpcvbhlar";
  };

  # Fails on 32-bit otherwise
  NIX_CFLAGS_COMPILE = [
    "-Wno-error=int-to-pointer-cast"
    "-Wno-error=pointer-to-int-cast"
    "-Wno-error=incompatible-pointer-types"
  ];

  postPatch = ''
    patchShebangs ./configure
    patchShebangs ./scripts/
  '';

  enableParallelBuilding = true;

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "A Linux System call fuzz tester";
    homepage = https://codemonkey.org.uk/projects/trinity/;
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
