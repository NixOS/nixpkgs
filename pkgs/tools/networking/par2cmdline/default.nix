{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name    = "par2cmdline-${version}";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "Parchive";
    repo = "par2cmdline";
    rev = "v${version}";
    sha256 = "1hkb1brz70p79rv7dlzhnl1invjmkll81rcpnhwvafv1yriklfai";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = https://github.com/Parchive/par2cmdline;
    description = "PAR 2.0 compatible file verification and repair tool";
    longDescription = ''
      par2cmdline is a program for creating and using PAR2 files to detect
      damage in data files and repair them if necessary. It can be used with
      any kind of file.
    '';
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.muflax ];
    platforms = platforms.all;
  };
}
