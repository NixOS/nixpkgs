{ stdenv, fetchgit, libmowgli, pkgconfig, git, gettext, pcre, libidn, cracklib, openssl }:

stdenv.mkDerivation rec {
  pname = "atheme";
  version = "7.2.10-r2";

  src = fetchgit {
    url = "https://github.com/atheme/atheme.git";
    rev = "v${version}";
    sha256 = "1yasfvbmixj4zzfv449hlcp0ms5c250lrshdy6x6l643nbnix4y9";
    leaveDotGit = true;
  };

  nativeBuildInputs = [ pkgconfig git gettext ];
  buildInputs = [ libmowgli pcre libidn cracklib openssl ];

  configureFlags = [
    "--with-pcre"
    "--with-libidn"
    "--with-cracklib"
    "--enable-large-net"
    "--enable-contrib"
    "--enable-reproducible-builds"
  ];

  meta = with stdenv.lib; {
    description = "A set of services for IRC networks";
    homepage = "https://atheme.github.io/";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ leo60228 ];
  };
}
