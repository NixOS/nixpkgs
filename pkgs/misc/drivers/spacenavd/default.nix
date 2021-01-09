{ fetchFromGitHub, stdenv, libX11, libXi }:

with stdenv.lib;

let
  pname = "spacenavd";
  version = "0.8";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";
  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jkkmHd5Vk6Pyd6otEgTXh4WwMqJ6fkts0enux0pl4P8=";
  };

  buildInputs = [ libX11 libXi ];

  meta = {
    description = "Free user-space driver for 6-dof space-mice. ";
    maintainers = [ maintainers.leenaars ];
    platforms = platforms.unix;
    license = licenses.gpl3;
    homepage = "http://spacenav.sourceforge.net/";
  };
}
