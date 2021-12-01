{ lib, stdenv, fetchFromGitHub, autoreconfHook, libtool }:

stdenv.mkDerivation rec {
  version="1.33";
  pname = "mxt-app";

  src = fetchFromGitHub {
    owner = "atmel-maxtouch";
    repo = "mxt-app";
    rev = "v${version}";
    sha256 = "sha256-PgIIxoyR7UA5y4UZ6meJERrbi1Bov03pJkN5St4BWss=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libtool ];

  hardeningDisable = [ "fortify" ];

  meta = with lib; {
    description = "Command line utility for Atmel maXTouch devices";
    homepage = "https://github.com/atmel-maxtouch/mxt-app";
    license = licenses.bsd2;
    maintainers = [ maintainers.colemickens ];
    platforms = platforms.linux;
  };
}
