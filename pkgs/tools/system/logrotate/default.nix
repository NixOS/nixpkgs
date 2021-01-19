{ lib, stdenv, fetchFromGitHub, gzip, popt, autoreconfHook
, mailutils ? null
}:

stdenv.mkDerivation rec {
  pname = "logrotate";
  version = "3.18.0";

  src = fetchFromGitHub {
    owner = "logrotate";
    repo = "logrotate";
    rev = version;
    sha256 = "sha256-OFGXwaTabyuIgeC2ON68m83rzVxomk8QL6xwyrVV654=";
  };

  # Logrotate wants to access the 'mail' program; to be done.
  patchPhase = ''
    sed -i -e 's,[a-z/]\+gzip,${gzip}/bin/gzip,' \
           -e 's,[a-z/]\+gunzip,${gzip}/bin/gunzip,' configure.ac

    ${lib.optionalString (mailutils != null) ''
    sed -i -e 's,[a-z/]\+mail,${mailutils}/bin/mail,' configure.ac
    ''}
  '';

  autoreconfPhase = ''
    ./autogen.sh
  '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ popt ];

  meta = {
    homepage = "https://fedorahosted.org/releases/l/o/logrotate/";
    description = "Rotates and compresses system logs";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.viric ];
    platforms = lib.platforms.all;
  };
}
