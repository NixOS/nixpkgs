{ stdenv, fetchurl, autoreconfHook, libsass }:

stdenv.mkDerivation rec {
  name = "sassc-${version}";
  version = "3.3.2";

  src = fetchurl {
    url = "https://github.com/sass/sassc/archive/${version}.tar.gz";
    sha256 = "15a2b2698639dfdc7bd6a5ba7a9ecdaf8ebb9f15503fb04dea1be3133308e41d";
  };

  patchPhase = ''
    export SASSC_VERSION=${version}
  '';

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libsass ];

  meta = with stdenv.lib; {
    description = "A front-end for libsass";
    homepage = https://github.com/sass/sassc/;
    license = licenses.mit;
    maintainers = with maintainers; [ codyopel pjones ];
    platforms = platforms.unix;
  };
}
