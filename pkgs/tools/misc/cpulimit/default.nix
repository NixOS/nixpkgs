{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "cpulimit";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "opsengine";
    repo = "cpulimit";
    rev = "v${version}";
    sha256 = "1dz045yhcsw1rdamzpz4bk8mw888in7fyqk1q1b3m1yk4pd1ahkh";
  };

  patches = [ ./remove-sys-sysctl.h.patch ./get-missing-basename.patch ];


  installPhase = ''
    mkdir -p $out/bin
    cp src/cpulimit $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/opsengine/cpulimit";
    description = "CPU usage limiter";
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    mainProgram = "cpulimit";
    maintainers = [ maintainers.jsoo1 ];
  };
}
