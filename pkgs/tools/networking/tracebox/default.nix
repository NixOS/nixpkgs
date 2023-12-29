{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, libpcap
, lua5_1
, json_c
, testers
, tracebox
}:
stdenv.mkDerivation rec {
  pname = "tracebox";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "tracebox";
    repo = "tracebox";
    rev = "v${version}";
    hash = "sha256-1KBJ4uXa1XpzEw23IjndZg+aGJXk3PVw8LYKAvxbxCA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    libpcap
    lua5_1
    json_c
  ];

  postPatch = ''
    sed -i configure.ac \
      -e 's,$(git describe .*),${version},'
  '';

  configureFlags = [
    "--with-lua=yes"
    "--with-libpcap=yes"
  ];

  env = {
    CXXFLAGS = "-std=c++14";
    LUA_LIB = "-llua";
    PCAPLIB = "-lpcap";
  };

  enableParallelBuilding = true;

  passthru.tests.version = testers.testVersion {
    package = tracebox;
    command = "tracebox -V";
  };

  meta = with lib; {
    homepage = "http://www.tracebox.org/";
    description = "A middlebox detection tool";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ck3d ];
    platforms = platforms.linux;
  };
}
