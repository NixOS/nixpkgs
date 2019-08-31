{ stdenv, fetchFromGitHub, cmake, ninja, gflags, libsodium, protobuf }:

stdenv.mkDerivation rec {
  pname = "eternal-terminal";
  version = "5.1.10";

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTCP";
    rev = "refs/tags/et-v${version}";
    sha256 = "0jh89229bd9s82h3aj6faaybwr5xvnk8w2kgz47gq263pz021zpl";
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
