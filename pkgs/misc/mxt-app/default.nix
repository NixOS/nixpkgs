{ stdenv, fetchFromGitHub, autoreconfHook, libtool }:

stdenv.mkDerivation rec {
  version="1.28";
  pname = "mxt-app";

  src = fetchFromGitHub {
    owner = "atmel-maxtouch";
    repo = "mxt-app";
    rev = "v${version}";
    sha256 = "1z2mir4ib9xzxmy0daazzvlga41n80zch1xyp1iz98rrdsnvd1la";
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
