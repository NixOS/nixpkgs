{ stdenv, fetchFromGitHub, autoreconfHook, libtool }:

stdenv.mkDerivation rec {
  version="1.32";
  pname = "mxt-app";

  src = fetchFromGitHub {
    owner = "atmel-maxtouch";
    repo = "mxt-app";
    rev = "v${version}";
    sha256 = "1z1g5h14j3yw3r9phgir33s9j07ns9c0r5lkl49940pzqycnrwbj";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libtool ];

  hardeningDisable = [ "fortify" ];

  meta = with stdenv.lib; {
    description = "Command line utility for Atmel maXTouch devices";
    homepage = "https://github.com/atmel-maxtouch/mxt-app";
    license = licenses.bsd2;
    maintainers = [ maintainers.colemickens ];
    platforms = platforms.linux;
  };
}
