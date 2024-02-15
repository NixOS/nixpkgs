{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ctrtool";
  version = "0.7";

  src = fetchFromGitHub {
    owner  = "jakcron";
    repo   = "Project_CTR";
    rev    = "ctrtool-v${version}";
    sha256 = "07aayck82w5xcp3si35d7ghybmrbqw91fqqvmbpjrjcixc6m42z7";
  };

  sourceRoot = "${src.name}/ctrtool";

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "CXX=${stdenv.cc.targetPrefix}c++"];
  enableParallelBuilding = true;

  installPhase = "
    mkdir $out/bin -p
    cp ctrtool${stdenv.hostPlatform.extensions.executable} $out/bin/
  ";

  meta = with lib; {
    license = licenses.mit;
    description = "A tool to extract data from a 3ds rom";
    platforms = platforms.linux;
    maintainers = [ maintainers.marius851000 ];
    mainProgram = "ctrtool";
  };

}
