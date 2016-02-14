{ stdenv, fetchFromGitHub, cmake, bison, flex, openssl, pcre, libmilter, opendkim }:

stdenv.mkDerivation rec {
  name = "rmilter-${version}";
  version = "1.6.7";
  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = "rmilter";
    rev = version;
    sha256 = "1syviydlv4m1isl0r52sk4s0a75fyk788j1z3yvfzzf1hga333gn";
  };

  nativeBuildInputs = [ bison cmake flex ];
  buildInputs = [ libmilter openssl pcre opendkim];

  meta = with stdenv.lib; {
    homepage = "https://github.com/vstakhov/rmilter";
    license = licenses.bsd2; 
    description = "server, used to integrate rspamd and milter compatible MTA, for example postfix or sendmail";
    maintainers = maintainers.avnik;
  };
}
