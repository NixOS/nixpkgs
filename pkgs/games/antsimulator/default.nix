{ lib, stdenv, fetchFromGitHub, cmake, sfml }:

stdenv.mkDerivation rec {
  pname = "antsimulator";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "johnBuffer";
    repo = "AntSimulator";
    rev = "v${version}";
    sha256 = "0wz80971rf86kb7mcnxwrq75vriwhmyir5s5n3wzml12rzfnj5f1";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ sfml ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 ./AntSimulator $out/bin/antsimulator
  '';

  meta = with lib; {
    homepage = "https://github.com/johnBuffer/AntSimulator";
    description = "Simple Ants simulator";
    license = licenses.free;
    maintainers = with maintainers; [ ivar ];
    platforms = platforms.unix;
  };
}
