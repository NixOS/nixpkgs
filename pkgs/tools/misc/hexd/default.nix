{ stdenv, fetchFromGitHub }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "hexd";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "FireyFly";
    repo = "hexd";
    rev = "v${version}";
    sha256 = "1lm0mj5c71id5kpqar8n44023s1kymb3q45nsz0hjh9v7p8libp0";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Colourful, human-friendly hexdump tool";
    homepage = "https://github.com/FireyFly/hexd";
    maintainers = [ maintainers.FireyFly ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
