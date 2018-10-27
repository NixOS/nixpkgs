{ stdenv, fetchFromGitHub, cmake, ninja, gflags, libsodium, protobuf }:

stdenv.mkDerivation rec {
  name = "eternal-terminal-${version}";
  version = "5.1.7";

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTCP";
    rev = "refs/tags/et-v${version}";
    sha256 = "17ndpkpyh8hwr6v7ac6029sja95nhn9c1g8r93g20rp0vz3r6lpa";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ gflags libsodium protobuf ];

  meta = with stdenv.lib; {
    description = "Remote shell that automatically reconnects without interrupting the session";
    license = licenses.asl20;
    homepage = https://mistertea.github.io/EternalTCP/;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.dezgeg ];
  };
}
