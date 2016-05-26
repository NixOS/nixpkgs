{ stdenv, fetchFromGitHub, pkgconfig, gtk2, mednafen }:

stdenv.mkDerivation rec {

  version = "0.8";
  name = "mednaffe-${version}";

  src = fetchFromGitHub {
	repo = "mednaffe";
	owner = "AmatCoder";
	rev = "v${version}";
	sha256 = "1j4py4ih14fa6dv0hka03rs4mq19ir83qkbxsz3695a4phmip0jr";
  };

  prePatch = ''
    substituteInPlace src/mednaffe.c --replace "binpath = NULL" "binpath = g_strdup( \"${mednafen}/bin/mednafen\" )"
  '';

  buildInputs = [ pkgconfig gtk2 mednafen ];

  meta = with stdenv.lib; {
    description = "A GTK based frontend for mednafen";
    homepage = https://github.com/AmatCoder/mednaffe;
    license = licenses.gpl3;
    maintainers = [ maintainers.sheenobu ];
    platforms = platforms.linux;
  };
}
