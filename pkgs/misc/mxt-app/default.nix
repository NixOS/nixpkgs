{ stdenv, fetchFromGitHub, makeWrapper, autoconf, automake, libtool }:

stdenv.mkDerivation rec{
  version="1.26";
  name = "mxt-app-${version}";

  src = fetchFromGitHub {
    owner = "atmel-maxtouch";
    repo = "mxt-app";
    rev = "v${version}";
    sha256 = "07afdgh8pnhgh2372cf5pqy6p7l6w3ing2hwnvz6db8wxw59n48h";
  };

  buildInputs = [ autoconf automake libtool ];
  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "Command line utility for Atmel maXTouch devices";
    homepage = http://github.com/atmel-maxtouch/mxt-app;
    license = licenses.bsd2;
    maintainers = [ maintainers.colemickens ];
    platforms = platforms.unix;
  };
}
