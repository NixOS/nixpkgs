{ stdenv, fetchurl, gettext, perl, gnutls ? null }:

stdenv.mkDerivation rec {
  name = "wget-1.12";

  src = fetchurl {
    url = "mirror://gnu/wget/${name}.tar.bz2";
    sha256 = "16msgly5xn0qj6ngsw34q9j7ag8jkci6020w21d30jgqw8wdj8y8";
  };

  patches = [ ./gnutls-support.patch ];

  preConfigure =
    '' for i in "doc/texi2pod.pl" "tests/run-px" "util/rmold.pl"
       do
         sed -i "$i" -e 's|/usr/bin.*perl|${perl}/bin/perl|g'
       done
    '';

  buildInputs = [ gettext perl ]
    ++ stdenv.lib.optional (gnutls != null) gnutls;

  configureFlags =
    if gnutls != null
    then "--with-ssl=gnutls"
    else "";

  doCheck = true;

  meta = {
    description = "GNU Wget, a tool for retrieving files using HTTP, HTTPS, and FTP";

    longDescription =
      '' GNU Wget is a free software package for retrieving files using HTTP,
         HTTPS and FTP, the most widely-used Internet protocols.  It is a
         non-interactive commandline tool, so it may easily be called from
         scripts, cron jobs, terminals without X-Windows support, etc.
      '';

    license = "GPLv3+";

    homepage = http://www.gnu.org/software/wget/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
