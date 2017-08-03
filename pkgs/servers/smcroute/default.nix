{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "smcroute-${version}";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "smcroute";
    rev = version;
    sha256 = "0a1sgf9p39gbfrh7bhfg1hjqa6y18i7cig7bffmv7spqnvb50zx5";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Static multicast routing daemon";
    homepage = http://troglobit.com/smcroute.html;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz ];
    platforms = with platforms; (linux ++ freebsd ++ netbsd ++ openbsd);
  };
}
