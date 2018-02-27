{ stdenv, fetchFromGitHub, mailutils, gzip, popt, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "logrotate-${version}";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "logrotate";
    repo = "logrotate";
    rev = version;
    sha256 = "0b7dnch74pddml3ysavizq26jgwdv0rjmwc8lf6zfvn9fjz19vvs";
  };

  # Logrotate wants to access the 'mail' program; to be done.
  patchPhase = ''
    sed -i -e 's,[a-z/]\+gzip,${gzip}/bin/gzip,' \
           -e 's,[a-z/]\+gunzip,${gzip}/bin/gunzip,' \
           -e 's,[a-z/]\+mail,${mailutils}/bin/mail,' configure.ac
  '';

  autoreconfPhase = ''
    ./autogen.sh
  '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ popt ];

  meta = {
    homepage = https://fedorahosted.org/releases/l/o/logrotate/;
    description = "Rotates and compresses system logs";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
