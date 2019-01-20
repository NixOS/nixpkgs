{ stdenv, fetchurl, gettext, pkgconfig, perlPackages
, libidn2, zlib, pcre, libuuid, libiconv, libintl
, python3, lzip
, libpsl ? null
, openssl ? null }:

stdenv.mkDerivation rec {
  name = "wget-${version}";
  version = "1.20.1";

  src = fetchurl {
    url = "mirror://gnu/wget/${name}.tar.lz";
    sha256 = "0a29qsqxkk8145vkyy35q5a1wc7qzwx3qj3gmfrkmi9xs96yhqqg";
  };

  patches = [
    ./remove-runtime-dep-on-openssl-headers.patch
  ];

  preConfigure = ''
    patchShebangs doc

  '' + stdenv.lib.optionalString doCheck ''
    # Work around lack of DNS resolution in chroots.
    for i in "tests/"*.pm "tests/"*.px
    do
      sed -i "$i" -e's/localhost/127.0.0.1/g'
    done
  '';

  nativeBuildInputs = [ gettext pkgconfig perlPackages.perl lzip libiconv libintl ];
  buildInputs = [ libidn2 zlib pcre libuuid ]
    ++ stdenv.lib.optionals doCheck [ perlPackages.IOSocketSSL perlPackages.LWP python3 ]
    ++ stdenv.lib.optional (openssl != null) openssl
    ++ stdenv.lib.optional (libpsl != null) libpsl
    ++ stdenv.lib.optional stdenv.isDarwin perlPackages.perl;

  configureFlags = [
    (stdenv.lib.withFeatureAs (openssl != null) "ssl" "openssl")
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tool for retrieving files using HTTP, HTTPS, and FTP";

    longDescription =
      '' GNU Wget is a free software package for retrieving files using HTTP,
         HTTPS and FTP, the most widely-used Internet protocols.  It is a
         non-interactive commandline tool, so it may easily be called from
         scripts, cron jobs, terminals without X-Windows support, etc.
      '';

    license = licenses.gpl3Plus;

    homepage = https://www.gnu.org/software/wget/;

    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.all;
  };
}
