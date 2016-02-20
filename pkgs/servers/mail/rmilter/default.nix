{ stdenv, fetchFromGitHub, cmake, bison, flex, openssl, pcre, libmilter, opendkim }:

stdenv.mkDerivation rec {
  name = "rmilter-${version}";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = "rmilter";
    rev = version;
    sha256 = "04xalaxq5xgg5ls0f4ayp8yhzdfq5gqjb8qwfyha3mrx4dqrgh7s";
  };

  nativeBuildInputs = [ bison cmake flex ];
  buildInputs = [ libmilter openssl pcre opendkim ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/vstakhov/rmilter";
    license = licenses.bsd2;
    description = ''
      Daemon to integrate rspamd and milter compatible MTA, for example
      postfix or sendmail
    '';
    maintainers = with maintainers; [ avnik fpletz ];
  };
}
