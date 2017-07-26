{ stdenv, fetchFromGitHub, autoreconfHook, libtool }:

stdenv.mkDerivation rec{
  version="1.27";
  name = "mxt-app-${version}";

  src = fetchFromGitHub {
    owner = "atmel-maxtouch";
    repo = "mxt-app";
    rev = "v${version}";
    sha256 = "0m1qxsdkwgajyd0sdw909l4w31csa26nw0xzr9ldddnvzb1va05h";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libtool ];
 
  hardeningDisable = [ "fortify" ];

  meta = with stdenv.lib; {
    description = "Command line utility for Atmel maXTouch devices";
    homepage = http://github.com/atmel-maxtouch/mxt-app;
    license = licenses.bsd2;
    maintainers = [ maintainers.colemickens ];
    platforms = platforms.unix;
  };
}
