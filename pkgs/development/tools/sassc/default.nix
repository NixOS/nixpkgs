{ lib, stdenv, fetchFromGitHub, autoreconfHook, libsass }:

stdenv.mkDerivation rec {
  pname = "sassc";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "sass";
    repo = pname;
    rev = version;
    sha256 = "1sxm54mkhs9m4vnl7vn11y17mhzamc403hv3966j1c7p2rbzg5pv";
  };

  patchPhase = ''
    export SASSC_VERSION=${version}
  '';

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libsass ];

  meta = with lib; {
    description = "A front-end for libsass";
    homepage = "https://github.com/sass/sassc/";
    license = licenses.mit;
    maintainers = with maintainers; [ codyopel pjones ];
    platforms = platforms.unix;
  };
}
