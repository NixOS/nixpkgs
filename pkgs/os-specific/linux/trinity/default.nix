{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "trinity-${version}";
  version = "1.8-git-2018-09-21";

  src = fetchFromGitHub {
    owner = "kernelslacker";
    repo = "trinity";
    rev = "9f6f9f916da3b42cef2e7c30101ff4b0397df736";
    sha256 = "09bjclgr31dhdqhyig84263q9l59x1q3ppa89sxbmg0yn6ixrc9h";
  };

  # Fails on 32-bit otherwise
  NIX_CFLAGS_COMPILE = stdenv.lib.optionals stdenv.targetPlatform.is32bit [
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
