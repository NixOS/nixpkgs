{ stdenv, fetchFromGitHub, mailutils, gzip, popt, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "logrotate-${version}";
  version = "3.12.3";

  src = fetchFromGitHub {
    owner = "logrotate";
    repo = "logrotate";
    rev = version;
    sha256 = "04ygb709fj4ai8m2f1c6imzcmkdvr3ib5zf5qw2lif4fsb30jvyi";
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
