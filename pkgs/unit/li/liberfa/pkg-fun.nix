{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "erfa";
  version = "2.0.0";

  nativeBuildInputs = [ autoreconfHook ];

  src = fetchFromGitHub {
    owner = "liberfa";
    repo = "erfa";
    rev = "v${version}";
    sha256 = "sha256-xBE8mWwmvlu0v3Up5y6J8jMhToMSACdKeQzPJoG8LWk=";
  };

  configureFlags = [ "--enable-shared" ];

  meta = with lib; {
    description = "Essential Routines for Fundamental Astronomy";
    homepage = "https://github.com/liberfa/erfa";
    maintainers = with maintainers; [ mir06 ];
    license = {
      url = "https://github.com/liberfa/erfa/blob/master/LICENSE";
      free = true;
    };
  };
}
