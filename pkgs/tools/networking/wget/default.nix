{ stdenv, fetchurl, gettext, perl, LWP, gnutls ? null }:

stdenv.mkDerivation rec {
  name = "wget-1.15";

  src = fetchurl {
    url = "mirror://gnu/wget/${name}.tar.xz";
    sha256 = "1yw0sk4mrs7bvga3c79rkbhxivmw8cs3b5wq3cglp1f9ai1mz2ni";
  };

  patches = stdenv.lib.optional stdenv.isDarwin ./iri-test.patch;

  preConfigure = stdenv.lib.optionalString doCheck
    '' for i in "doc/texi2pod.pl" "tests/run-px" "util/rmold.pl"
       do
         sed -i "$i" -e 's|/usr/bin.*perl|${perl}/bin/perl|g'
       done

       # Work around lack of DNS resolution in chroots.
       for i in "tests/"*.pm "tests/"*.px
       do
         sed -i "$i" -e's/localhost/127.0.0.1/g'
       done
    '';

  nativeBuildInputs = [ gettext ];
  buildInputs =
    stdenv.lib.optionals doCheck [ perl LWP ]
    ++ stdenv.lib.optional (gnutls != null) gnutls;

  configureFlags =
    if gnutls != null
    then "--with-ssl=gnutls"
    else "--without-ssl";

  doCheck = (perl != null);

  meta = {
    description = "GNU Wget, a tool for retrieving files using HTTP, HTTPS, and FTP";

    longDescription =
      '' GNU Wget is a free software package for retrieving files using HTTP,
         HTTPS and FTP, the most widely-used Internet protocols.  It is a
         non-interactive commandline tool, so it may easily be called from
         scripts, cron jobs, terminals without X-Windows support, etc.
      '';

    license = stdenv.lib.licenses.gpl3Plus;

    homepage = http://www.gnu.org/software/wget/;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
