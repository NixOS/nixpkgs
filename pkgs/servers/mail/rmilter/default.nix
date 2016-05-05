{ stdenv, fetchFromGitHub, cmake, bison, flex, openssl, pcre, libmilter, opendkim,
 libmemcached }:

let patchedLibmilter = stdenv.lib.overrideDerivation  libmilter (_ : {
    patches = libmilter.patches ++ [ ./fd-passing-libmilter.patch ];
});
in

stdenv.mkDerivation rec {
  name = "rmilter-${version}";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = "rmilter";
    rev = version;
    sha256 = "0d2hv39sbzsv3bkbx433vpdqgcjv71v2kkaz4k065xppi35wa2js";
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
  };
}
