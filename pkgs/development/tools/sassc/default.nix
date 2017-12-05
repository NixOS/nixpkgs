{ stdenv, fetchurl, autoreconfHook, libsass }:

stdenv.mkDerivation rec {
  name = "sassc-${version}";
  version = "3.4.5";

  src = fetchurl {
    url = "https://github.com/sass/sassc/archive/${version}.tar.gz";
    sha256 = "1xk4kmmvziz9sal3swpqa10q0s289xjpcz8aggmly8mvxvmngsi9";
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
