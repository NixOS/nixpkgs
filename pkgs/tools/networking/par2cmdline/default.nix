{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name    = "par2cmdline-${version}";
  version = "0.6.13";

  src = fetchFromGitHub {
    owner = "Parchive";
    repo = "par2cmdline";
    rev = "v${version}";
    sha256 = "0jxixkc8vid933nph2mvhgz58my42kwjlzbir38hml2xrzq00d8f";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = https://github.com/BlackIkeEagle/par2cmdline;
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
