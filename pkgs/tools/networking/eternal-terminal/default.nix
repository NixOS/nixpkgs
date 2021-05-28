{ stdenv
, fetchFromGitHub
, cmake
, gflags
, libsodium
, protobuf
}:

stdenv.mkDerivation rec {
  pname = "eternal-terminal";
  version = "6.0.11";

  src = fetchFromGitHub {
    owner = "MisterTea";
    repo = "EternalTerminal";
    rev = "et-v${version}";
    sha256 = "0yjf639ldfaxrw4pbg9avdkhhmcpnx58j3x70zskvgkajny8yqqr";
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
