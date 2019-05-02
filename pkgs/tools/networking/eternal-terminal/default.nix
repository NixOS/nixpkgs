{ stdenv, fetchFromGitHub, cmake, ninja, gflags, libsodium, protobuf }:

stdenv.mkDerivation rec {
  name = "eternal-terminal-${version}";
  version = "5.1.9";

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTCP";
    rev = "refs/tags/et-v${version}";
    sha256 = "07ynkcnk3z6wafdlnzdxcd308cw1rzabxyq47ybj79lyji3wsgk7";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ gflags libsodium protobuf ];

  meta = with stdenv.lib; {
    description = "Remote shell that automatically reconnects without interrupting the session";
    license = licenses.asl20;
    homepage = https://mistertea.github.io/EternalTerminal/;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.dezgeg ];
  };
}
