{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "oksh";
  version = "6.8.1";

  src = fetchFromGitHub {
    owner = "ibara";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0lny550qfanysc4pqs0mxxx8zyz6plv9ll8y05gz0xmq9vx5384r";
  };

  meta = with lib; {
    description = "Portable OpenBSD ksh, based on the Public Domain Korn Shell (pdksh)";
    homepage = "https://github.com/ibara/oksh";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.all;
  };
}
