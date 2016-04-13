{ stdenv, fetchzip, autoreconfHook }:

stdenv.mkDerivation rec {
  name    = "par2cmdline-${version}";
  version = "0.6.11";

  src = fetchzip {
    url = "https://github.com/BlackIkeEagle/par2cmdline/archive/v${version}.tar.gz";
    sha256 = "0maywssv468ia7rf8jyq4axwahgli3nfykl7x3zip503psywjj8a";
  };

  buildInputs = [ autoreconfHook ];

  meta = {
    homepage = https://github.com/BlackIkeEagle/par2cmdline;
    description = "PAR 2.0 compatible file verification and repair tool";
    longDescription = ''
      par2cmdline is a program for creating and using PAR2 files to detect
      damage in data files and repair them if necessary. It can be used with
      any kind of file.
    '';
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.muflax ];
    platforms = stdenv.lib.platforms.all;
  };
}
