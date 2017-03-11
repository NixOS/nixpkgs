{ stdenv, fetchurl, gettext, libidn, pkgconfig
, perl, perlPackages, LWP, python3
, libiconv, libpsl ? null, openssl ? null }:

stdenv.mkDerivation rec {
  name = "wget-1.18";

  src = fetchurl {
    url = "mirror://gnu/wget/${name}.tar.xz";
    sha256 = "1hcwx8ww3sxzdskkx3l7q70a7wd6569yrnjkw9pw013cf9smpddm";
  };

  patches = [
    ./remove-runtime-dep-on-openssl-headers.patch
    (fetchurl {
      name = "CVE-2017-6508";
      url = "http://git.savannah.gnu.org/cgit/wget.git/patch/?id=4d729e322fae359a1aefaafec1144764a54e8ad4";
      sha256 = "14r0c5y3w3gavxp2d9yq8xji82izi5sx0sjv6jpmk6zp6cnr7cjf";
    })
  ];

  preConfigure = ''
    patchShebangs doc

  '' + stdenv.lib.optionalString doCheck ''
    # Work around lack of DNS resolution in chroots.
    for i in "tests/"*.pm "tests/"*.px
    do
      sed -i "$i" -e's/localhost/127.0.0.1/g'
    done
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export LIBS="-liconv -lintl"
  '';

  nativeBuildInputs = [ gettext pkgconfig perl ];
  buildInputs = [ libidn libiconv libpsl ]
    ++ stdenv.lib.optionals doCheck [ perlPackages.IOSocketSSL LWP python3 ]
    ++ stdenv.lib.optional (openssl != null) openssl
    ++ stdenv.lib.optional stdenv.isDarwin perl;

  configureFlags =
    if openssl != null then "--with-ssl=openssl" else "--without-ssl";

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

    homepage = http://www.gnu.org/software/wget/;

    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.all;
  };
}
