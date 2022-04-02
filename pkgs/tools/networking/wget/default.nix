{ lib, stdenv, fetchurl, gettext, pkg-config, perlPackages
, libidn2, zlib, pcre, libuuid, libiconv, libintl
, python3, lzip
, libpsl ? null
, openssl ? null }:

stdenv.mkDerivation rec {
  pname = "wget";
  version = "1.21.3";

  src = fetchurl {
    url = "mirror://gnu/wget/${pname}-${version}.tar.lz";
    sha256 = "sha256-29L7XkcUnUdS0Oqg2saMxJzyDUbfT44yb/yPGLKvTqU=";
  };

  patches = [
    ./remove-runtime-dep-on-openssl-headers.patch
  ];

  preConfigure = ''
    patchShebangs doc

  '' + lib.optionalString doCheck ''
    # Work around lack of DNS resolution in chroots.
    for i in "tests/"*.pm "tests/"*.px
    do
      sed -i "$i" -e's/localhost/127.0.0.1/g'
    done
  '';

  nativeBuildInputs = [ gettext pkg-config perlPackages.perl lzip libiconv libintl ];
  buildInputs = [ libidn2 zlib pcre libuuid ]
    ++ lib.optionals doCheck [ perlPackages.IOSocketSSL perlPackages.LWP python3 ]
    ++ lib.optional (openssl != null) openssl
    ++ lib.optional (libpsl != null) libpsl
    ++ lib.optional stdenv.isDarwin perlPackages.perl;

  configureFlags = [
    (lib.withFeatureAs (openssl != null) "ssl" "openssl")
  ] ++ lib.optionals stdenv.isDarwin [
    # https://lists.gnu.org/archive/html/bug-wget/2021-01/msg00076.html
    "--without-included-regex"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Tool for retrieving files using HTTP, HTTPS, and FTP";

    longDescription =
      '' GNU Wget is a free software package for retrieving files using HTTP,
         HTTPS and FTP, the most widely-used Internet protocols.  It is a
         non-interactive commandline tool, so it may easily be called from
         scripts, cron jobs, terminals without X-Windows support, etc.
      '';

    license = licenses.gpl3Plus;

    homepage = "https://www.gnu.org/software/wget/";

    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.all;
  };
}
