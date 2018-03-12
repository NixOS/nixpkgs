{ stdenv, fetchurl, autoreconfHook, libsass }:

stdenv.mkDerivation rec {
  name = "sassc-${version}";
  version = "3.4.8";

  src = fetchurl {
    url = "https://github.com/sass/sassc/archive/${version}.tar.gz";
    sha256 = "02lnibrl6zgczkhvz01bdp0d2b0rbl69dfv5mdnbr4l8km7sa7b1";
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
