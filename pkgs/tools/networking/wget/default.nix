{ stdenv, fetchurl, gettext, libidn
, perl, perlPackages, LWP, python3
, gnutls ? null }:

stdenv.mkDerivation rec {
  name = "wget-1.16";

  src = fetchurl {
    url = "mirror://gnu/wget/${name}.tar.xz";
    sha256 = "1rxhr3jmgbwryzl51di4avqxw9m9j1z2aak8q1npns0p184xsqcj";
  };

  preConfigure = stdenv.lib.optionalString doCheck
    '' for i in "doc/texi2pod.pl" "util/rmold.pl"
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
  buildInputs = [ libidn ]
    ++ stdenv.lib.optionals doCheck [ perl perlPackages.IOSocketSSL LWP python3 ]
    ++ stdenv.lib.optional (gnutls != null) gnutls;

  configureFlags =
    if gnutls != null
    then "--with-ssl=gnutls"
    else "--without-ssl";

  doCheck = (perl != null && python3 != null);

  meta = with stdenv.lib; {
    description = "Tool for retrieving files using HTTP, HTTPS, and FTP";

    longDescription =
      '' GNU Wget is a free software package for retrieving files using HTTP,
         HTTPS and FTP, the most widely-used Internet protocols.  It is a
         non-interactive commandline tool, so it may easily be called from
         scripts, cron jobs, terminals without X-Windows support, etc.
      '';

    license = licenses.gpl3Plus;

    homepage = http://www.gnu.org/software/wget/;

    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.all;
  };
}
