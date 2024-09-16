{ lib, stdenv, fetchFromGitHub, gitUpdater }:

stdenv.mkDerivation rec {
  pname = "ctrtool";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner  = "jakcron";
    repo   = "Project_CTR";
    rev    = "ctrtool-v${version}";
    sha256 = "wjU/DJHrAHE3MSB7vy+swUDVPzw0Jrv4ymOjhfr0BBk=";
  };

  sourceRoot = "${src.name}/ctrtool";

  enableParallelBuilding = true;

  preBuild = ''
  make -j $NIX_BUILD_CORES deps
  '';

  # workaround for https://github.com/3DSGuy/Project_CTR/issues/145
  env.NIX_CFLAGS_COMPILE = "-O0";

  installPhase = "
    mkdir $out/bin -p
    cp bin/ctrtool${stdenv.hostPlatform.extensions.executable} $out/bin/
  ";

  passthru.updateScript = gitUpdater { rev-prefix = "ctrtool-v"; };

  meta = with lib; {
    license = licenses.mit;
    description = "Tool to extract data from a 3ds rom";
    platforms = platforms.linux;
    maintainers = [ maintainers.marius851000 ];
    mainProgram = "ctrtool";
  };

}
