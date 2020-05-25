{ stdenv
, fetchFromGitHub
, cmake
, gflags
, libsodium
, protobuf
}:

stdenv.mkDerivation rec {
  pname = "eternal-terminal";
  version = "6.0.7";

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTerminal";
    rev = "et-v${version}";
    sha256 = "03pdspggqxkmz95qb96pig5x0xw18hy9a7ivszydr32ry6kxxx1h";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gflags libsodium protobuf ];

  meta = with stdenv.lib; {
    description = "Remote shell that automatically reconnects without interrupting the session";
    license = licenses.asl20;
    homepage = "https://mistertea.github.io/EternalTerminal/";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ dezgeg pingiun ];
  };
}
