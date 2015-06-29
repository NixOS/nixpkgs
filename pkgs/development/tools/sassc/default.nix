{ stdenv, fetchurl, autoreconfHook, libsass }:

stdenv.mkDerivation rec {
  name = "sassc-${version}";
  version = "3.2.4";

  src = fetchurl {
    url = "https://github.com/sass/sassc/archive/${version}.tar.gz";
    sha256 = "0ksdfv9ff5smba4vbwr1wqf3bp908rnprkp6lfssj85h9ciqq896";
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
