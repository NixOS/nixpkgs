{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  doxygen,
  enableTool ? false,
  enableTest ? false,
}:

stdenv.mkDerivation rec {
  pname = "sockperf";
  version = "3.10";

  src = fetchFromGitHub {
    owner = "Mellanox";
    repo = "sockperf";
    rev = version;
    sha256 = "sha256-VvxL/bcn69uL7CBpDu4qwbKZwlC4N/kNeRX4k3UzxPI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    doxygen
  ];

  configureFlags =
    [ "--enable-doc" ]
    ++ lib.optional enableTest "--enable-test"
    ++ lib.optional enableTool "--enable-tool";

  doCheck = true;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Network Benchmarking Utility";
    homepage = "https://github.com/Mellanox/sockperf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.all;
    mainProgram = "sockperf";
  };
}
