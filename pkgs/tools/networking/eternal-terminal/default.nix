{ stdenv
, fetchFromGitHub
, cmake
, gflags
, libsodium
, protobuf
}:

stdenv.mkDerivation rec {
  pname = "eternal-terminal";
  version = "6.0.9";

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTerminal";
    rev = "et-v${version}";
    sha256 = "16s5m9i9fx370ssqnqxi01isrs9p3k7w8a4kkcgr4lq99vxys915";
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
