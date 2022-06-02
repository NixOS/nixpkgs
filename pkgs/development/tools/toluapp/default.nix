{ lib, stdenv, fetchFromGitHub, sconsPackages, lua }:

stdenv.mkDerivation rec {
  version = "1.0.93";
  pname = "toluapp";

  src = fetchFromGitHub {
    owner = "LuaDist";
    repo  = "toluapp";
    rev   = version;
    sha256 = "0zd55bc8smmgk9j4cf0jpibb03lgsvl0knpwhplxbv93mcdnw7s0";
  };

  nativeBuildInputs = [ sconsPackages.scons_3_0_1 ];
  buildInputs = [ lua ];

  patches = [ ./environ-and-linux-is-kinda-posix.patch ./headers.patch ];

  preConfigure = ''
    substituteInPlace config_posix.py \
      --replace /usr/local $out
  '';

  meta = with lib; {
    description = "A tool to integrate C/Cpp code with Lua";
    homepage = "http://www.codenix.com/~tolua/";
    license = licenses.mit;
    maintainers = with maintainers; [ vrthra ];
    mainProgram = "tolua++";
    platforms = with platforms; unix;
  };
}
