{ lib, stdenv, fetchFromGitHub, autoconf, automake }:

stdenv.mkDerivation rec {
  pname = "ndstool";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "devkitPro";
    repo = "ndstool";
    rev = "v${version}";
    sha256 = "0isnm0is5k6dgi2n2c3mysyr5hpwikp5g0s3ix7ms928z04l8ccm";
  };

  nativeBuildInputs = [ autoconf automake ];

  preConfigure = "./autogen.sh";

  meta = {
    homepage = "https://github.com/devkitPro/ndstool";
    description = "Tool to unpack and repack nds rom";
    maintainers = [ lib.maintainers.marius851000 ];
    license = lib.licenses.gpl3;
    mainProgram = "ndstool";
  };
}
