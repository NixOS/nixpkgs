{ stdenv, fetchurl, autoreconfHook, libsass }:

stdenv.mkDerivation rec {
  name = "sassc-${version}";
  version = "3.2.1";

  src = fetchurl {
    url = "https://github.com/sass/sassc/archive/${version}.tar.gz";
    sha256 = "18pp7ylcwfvfagvnpw660cdvv7cjl7pl9v8x7xr05fp2l6133rxw";
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
    maintainers = with maintainers; [ pjones ];
    platforms = platforms.unix;
  };
}
