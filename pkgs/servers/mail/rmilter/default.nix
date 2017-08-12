{ stdenv, fetchFromGitHub, cmake, bison, flex, pkgconfig, openssl, pcre
, libmilter, opendkim, libmemcached, glib }:

let patchedLibmilter = stdenv.lib.overrideDerivation  libmilter (_ : {
    patches = libmilter.patches ++ [ ./fd-passing-libmilter.patch ];
});
in

stdenv.mkDerivation rec {
  name = "rmilter-${version}";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = "rmilter";
    rev = version;
    sha256 = "1gbp6jah88l6xqgflim01ycyp63l733bgir65fxnnrmifj1qzymh";
  };

  nativeBuildInputs = [ bison cmake flex pkgconfig ];
  buildInputs = [ libmemcached patchedLibmilter openssl pcre opendkim glib ];

  meta = with stdenv.lib; {
    homepage = https://github.com/vstakhov/rmilter;
    license = licenses.asl20;
    description = ''
      Daemon to integrate rspamd and milter compatible MTA, for example
      postfix or sendmail
    '';
    maintainers = with maintainers; [ avnik fpletz ];
    platforms = with platforms; linux;
  };
}
