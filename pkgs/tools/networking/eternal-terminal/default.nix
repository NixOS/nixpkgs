{ stdenv, fetchFromGitHub, cmake, gflags, libsodium, protobuf }:

stdenv.mkDerivation rec {
  name = "eternal-terminal-${version}";
  version = "5.1.6";

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTCP";
    rev = "refs/tags/et-v${version}";
    sha256 = "0df573c5hi3hxa0d3m02zf2iyh841540dklj9lmp6faik8cp39jz";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gflags libsodium protobuf ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Remote shell that automatically reconnects without interrupting the session";
    license = licenses.asl20;
    homepage = https://mistertea.github.io/EternalTCP/;
    platforms = platforms.linux;
    maintainers = [ maintainers.dezgeg ];
  };
}
