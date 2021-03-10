{ lib, stdenv, fetchurl, gettext, pkg-config, perlPackages
, libidn2, zlib, pcre, libuuid, libiconv, libintl
, python3, lzip
, libpsl ? null
, openssl ? null }:

stdenv.mkDerivation rec {
  pname = "wget";
  version = "1.21.1";

  src = fetchurl {
    url = "mirror://gnu/wget/${pname}-${version}.tar.lz";
    sha256 = "sha256-25u+U0fm+qBvx4gF7rgIsmiXlFXq2QA6YIVpydT8kK0=";
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
