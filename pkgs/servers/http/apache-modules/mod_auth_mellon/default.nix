{ stdenv, apacheHttpd, autoconf, automake, autoreconfHook, curl, fetchFromGitHub, glib, lasso, libtool, libxml2, libxslt, openssl, pkgconfig, xmlsec }:

stdenv.mkDerivation rec {

  name = "mod_auth_mellon-${version}";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "UNINETT";
    repo = "mod_auth_mellon";
    rev = "v${version}";
    sha256 = "1p6v6vgrfvgvc5y2ygqyyxi0klpm3nxaw3fg35zmpmw663w8skqn";
  };

  patches = [
    ./fixdeps.patch
  ];

  buildInputs = [ apacheHttpd autoconf autoreconfHook automake curl glib lasso libtool libxml2 libxslt openssl pkgconfig xmlsec ];

  configureFlags = ["--with-apxs2=${apacheHttpd.dev}/bin/apxs" "--exec-prefix=$out"];

  installPhase = ''
    mkdir -p $out/bin
    cp ./mellon_create_metadata.sh $out/bin
    mkdir -p $out/modules
    cp ./.libs/mod_auth_mellon.so $out/modules
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/UNINETT/mod_auth_mellon;
    description = "An Apache module with a simple SAML 2.0 service provider";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };

}
