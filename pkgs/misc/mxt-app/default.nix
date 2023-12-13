{ lib, stdenv, fetchFromGitHub, autoreconfHook, libtool }:

stdenv.mkDerivation rec {
  version="1.36";
  pname = "mxt-app";

  src = fetchFromGitHub {
    owner = "atmel-maxtouch";
    repo = "mxt-app";
    rev = "v${version}";
    sha256 = "sha256-hS/4d7HUCoulY73Sn1+IAb/IWD4VDht78Tn2jdluzhU=";
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
    mainProgram = "mxt-app";
  };
}
