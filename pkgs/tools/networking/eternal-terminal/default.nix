{ stdenv, fetchFromGitHub, cmake, gflags, glog, libsodium, protobuf }:

stdenv.mkDerivation rec {
  name = "eternal-terminal-${version}";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTCP";
    rev = "refs/tags/et-v${version}";
    sha256 = "1zy30ccsddgs2wqwxphnx5i00j4gf69lr68mzg9x6imqfz0sbcjz";
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
