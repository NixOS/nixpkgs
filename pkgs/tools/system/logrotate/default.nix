{ stdenv, fetchFromGitHub, gzip, popt, autoreconfHook
, mailutils ? null
}:

stdenv.mkDerivation rec {
  name = "logrotate-${version}";
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "logrotate";
    repo = "logrotate";
    rev = version;
    sha256 = "094wv4d3gv5dmw55d0xij06lgcg5q9bmq49hipc2jhp4vdsj4xr5";
  };

  # Logrotate wants to access the 'mail' program; to be done.
  patchPhase = ''
    sed -i -e 's,[a-z/]\+gzip,${gzip}/bin/gzip,' \
           -e 's,[a-z/]\+gunzip,${gzip}/bin/gunzip,' configure.ac

    ${stdenv.lib.optionalString (mailutils != null) ''
    sed -i -e 's,[a-z/]\+mail,${mailutils}/bin/mail,' configure.ac
    ''}
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
