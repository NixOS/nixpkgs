{ stdenv, fetchFromGitHub, cmake, bison, flex, openssl, pcre, libmilter, opendkim,
 libmemcached }:

let patchedLibmilter = stdenv.lib.overrideDerivation  libmilter (_ : {
    patches = libmilter.patches ++ [ ./fd-passing-libmilter.patch ];
});
in

stdenv.mkDerivation rec {
  name = "rmilter-${version}";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = "rmilter";
    rev = version;
    sha256 = "1nmkv1h69yxfl20mf0x2wcx71crpnqif95xhslzahfbkm40m6fdc";
  };

  nativeBuildInputs = [ bison cmake flex ];
  buildInputs = [ libmemcached patchedLibmilter openssl pcre opendkim];

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
