{ lib, cmake, fetchFromGitHub, libGL, libiconv, libX11, openal, stdenv }:

stdenv.mkDerivation rec {
  pname = "cen64";
  version = "unstable-2021-03-12";

  src = fetchFromGitHub {
    owner = "n64dev";
    repo = "cen64";
    rev = "1b31ca9b3c3bb783391ab9773bd26c50db2056a8";
    sha256 = "0x1fz3z4ffl5xssiyxnmbhpjlf0k0fxsqn4f2ikrn17742dx4c0z";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libGL libiconv openal libX11 ];

  installPhase = ''
    runHook preInstall
    install -D {,$out/bin/}${pname}
    runHook postInstall
  '';

  meta = with lib; {
    description = "A Cycle-Accurate Nintendo 64 Emulator";
    license = licenses.bsd3;
    homepage = "https://github.com/n64dev/cen64";
    maintainers = [ maintainers._414owen ];
    platforms = [ "x86_64-linux" ];
  };
}
