{ stdenv, fetchFromGitHub, cmake, bison, flex, openssl, pcre, libmilter, opendkim,
 libmemcached }:

let patchedLibmilter = stdenv.lib.overrideDerivation  libmilter (_ : {
    patches = libmilter.patches ++ [ ./fd-passing-libmilter.patch ];
});
in

stdenv.mkDerivation rec {
  name = "rmilter-${version}";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = "rmilter";
    rev = version;
    sha256 = "0cplkc1acgysxn8id9wakd1fx0f76cazscpfqhrxyjbk5fb11ll4";
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
