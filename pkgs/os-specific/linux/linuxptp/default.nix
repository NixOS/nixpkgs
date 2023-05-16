{ lib, stdenv, fetchurl, linuxHeaders } :


stdenv.mkDerivation rec {
  pname = "linuxptp";
<<<<<<< HEAD
  version = "4.1";

  src = fetchurl {
    url = "mirror://sourceforge/linuxptp/${pname}-${version}.tgz";
    hash = "sha256-4XQ9RPggiJfjCJXaNXnmcP+Rm5FP60talJ8+Qh3d5TU=";
=======
  version = "3.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/linuxptp/${pname}-${version}.tgz";
    sha256 = "1nf0w4xyzg884v8blb81zkk6q8p6zbiq9lx61jdqwbbzkdgqbmll";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace incdefs.sh --replace \
       '/usr/include/linux/' "${linuxHeaders}/include/linux/"
  '';

  makeFlags = [ "prefix=" ];

  preInstall = ''
    export DESTDIR=$out
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Implementation of the Precision Time Protocol (PTP) according to IEEE standard 1588 for Linux";
    homepage = "https://linuxptp.sourceforge.net/";
    maintainers = [ maintainers.markuskowa ];
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
