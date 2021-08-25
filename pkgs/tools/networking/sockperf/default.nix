{ lib, stdenv, fetchFromGitHub, autoreconfHook, doxygen
, enableTool ? false
, enableTest ? false }:

stdenv.mkDerivation rec {
  pname = "sockperf";
  version = "3.7";

  src = fetchFromGitHub {
    owner = "Mellanox";
    repo = "sockperf";
    rev = version;
    sha256 = "MtpV21lCEAv7ARxk0dAxoOxxlqDM+skdQnPlqOvksjw=";
  };

  nativeBuildInputs = [ autoreconfHook doxygen ];

  configureFlags = [ "--enable-doc" ]
    ++ lib.optional enableTest "--enable-test"
    ++ lib.optional enableTool "--enable-tool";

  doCheck = true;

  meta = with lib; {
    description = "Network Benchmarking Utility";
    homepage = "https://github.com/Mellanox/sockperf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ angustrau ];
    platforms = platforms.all;
  };
}
