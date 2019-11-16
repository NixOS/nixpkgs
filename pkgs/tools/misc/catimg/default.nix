{ stdenv, fetchFromGitHub, cmake } :

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "catimg";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "posva";
    repo = pname;
    rev = version;
    sha256 = "0g9ywbgy162wiam9hc3yqpq5q4gyxa8fj4jskr3fdz8z8jjaabzz";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    license = licenses.mit;
    homepage = "https://github.com/posva/catimg";
    description = "Insanely fast image printing in your terminal";
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };

}
