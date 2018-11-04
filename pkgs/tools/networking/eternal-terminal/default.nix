{ stdenv, fetchFromGitHub, cmake, ninja, gflags, libsodium, protobuf }:

stdenv.mkDerivation rec {
  name = "eternal-terminal-${version}";
  version = "5.1.8";

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTCP";
    rev = "refs/tags/et-v${version}";
    sha256 = "0fq9a1fn0c77wfpypl3z7y23gbkw295ksy97wi9lhb5zj2m3dkq0";
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
