{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "smcroute-${version}";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "smcroute";
    rev = version;
    sha256 = "0mmwvjqbzhzwii4g6rz3ms9fhzppnhbsrhr4jqpih2y95cz039gg";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Static multicast routing daemon";
    homepage = "http://troglobit.com/smcroute.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz ];
    platforms = with platforms; (linux ++ freebsd ++ netbsd ++ openbsd);
  };
}
