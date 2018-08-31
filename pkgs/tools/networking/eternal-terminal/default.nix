{ stdenv, fetchFromGitHub, cmake, gflags, glog, libsodium, protobuf }:

stdenv.mkDerivation rec {
  name = "eternal-terminal-${version}";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTCP";
    rev = "refs/tags/et-v${version}";
    sha256 = "03bxzadlvhhxdn629hwx3dpsbkck3fpz2rrz0rbm48khimrqqag5";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gflags glog libsodium protobuf ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Remote shell that automatically reconnects without interrupting the session";
    license = licenses.asl20;
    homepage = https://mistertea.github.io/EternalTCP/;
    platforms = platforms.linux;
    maintainers = [ maintainers.dezgeg ];
  };
}
