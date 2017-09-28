{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk2, mednafen }:

stdenv.mkDerivation rec {
  name = "mednaffe-${version}";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "AmatCoder";
    repo = "mednaffe";
    rev = "v${version}";
    sha256 = "13l7gls430dcslpan39k0ymdnib2v6crdsmn6bs9k9g30nfnqi6m";
  };

  patchPhase = ''
    substituteInPlace src/mednaffe.c \
      --replace 'binpath = NULL' 'binpath = "${mednafen}/bin/mednafen"'
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ gtk2 mednafen ];

  meta = with stdenv.lib; {
    description = "A GTK based frontend for mednafen";
    homepage = https://github.com/AmatCoder/mednaffe;
    license = licenses.gpl3;
    maintainers = with maintainers; [ sheenobu ];
    platforms = platforms.linux;
  };
}
