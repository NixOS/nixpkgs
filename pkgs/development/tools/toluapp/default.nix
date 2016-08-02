{ stdenv, fetchFromGitHub, scons, lua }:

stdenv.mkDerivation rec {
  version = "1.0.93";
  name = "toluapp-${version}";

  src = fetchFromGitHub {
    owner = "LuaDist";
    repo  = "toluapp";
    rev   = "${version}";
    sha256 = "0zd55bc8smmgk9j4cf0jpibb03lgsvl0knpwhplxbv93mcdnw7s0";
  };

  buildInputs = [ lua scons ];

  patches = [ ./environ-and-linux-is-kinda-posix.patch ];

  preConfigure = ''
    substituteInPlace config_posix.py \
      --replace /usr/local $out
  '';

  buildPhase = ''scons'';

  installPhase = ''scons install'';

  meta = with stdenv.lib; {
    description = "A tool to integrate C/Cpp code with Lua";
    homepage = http://www.codenix.com/~tolua/;
    license = licenses.mit;
    maintainers = with maintainers; [ vrthra ];
    platforms = with platforms; unix;
  };
}
