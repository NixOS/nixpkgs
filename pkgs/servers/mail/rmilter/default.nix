{ stdenv, fetchFromGitHub, cmake, bison, flex, openssl, pcre, libmilter, opendkim
, libmemcached, glib, pkgconfig }:

let patchedLibmilter = stdenv.lib.overrideDerivation  libmilter (_ : {
    patches = libmilter.patches ++ [ ./fd-passing-libmilter.patch ];
});
in

stdenv.mkDerivation rec {
  name = "rmilter-${version}";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = "rmilter";
    rev = version;
    sha256 = "0pnk9a20phnvfddwvmak962mmgqsmdipsp2sm7aajh3340cwb3am";
  };

  nativeBuildInputs = [ bison cmake flex pkgconfig ];
  buildInputs = [ libmemcached patchedLibmilter openssl pcre opendkim glib ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/vstakhov/rmilter";
    license = licenses.asl20;
    description = ''
      Daemon to integrate rspamd and milter compatible MTA, for example
      postfix or sendmail
    '';
    maintainers = with maintainers; [ avnik fpletz ];
    platforms = with platforms; linux;
  };
}
