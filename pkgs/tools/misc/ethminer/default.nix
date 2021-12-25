{
  lib,
  stdenv,
  fetchFromGitHub,
  opencl-headers,
  cmake,
  jsoncpp,
  boost,
  makeWrapper,
  cudatoolkit,
  cudaSupport,
  mesa,
  ethash,
  opencl-info,
  ocl-icd,
  openssl,
  pkg-config,
  cli11
}:

stdenv.mkDerivation rec {
  pname = "ethminer";
  version = "0.20.0";

  src =
    fetchFromGitHub {
      owner = "ethereum-mining";
      repo = "ethminer";
      rev = "e55fbdc2f985b852de61c1b541eb1570ad69dbf0"; # https://github.com/ethereum-mining/ethminer/pull/2377; FIXME change once upstream releases
      sha256 = "sha256-ugKMuoBqEztCrOltNK+VXTKZjgwjyHr6pLn+xenhCDA=";
      fetchSubmodules = true;
    };

  # NOTE: dbus is broken
  cmakeFlags = [
    "-DHUNTER_ENABLED=OFF"
    "-DETHASHCUDA=ON"
    "-DAPICORE=ON"
    "-DETHDBUS=OFF"
    "-DCMAKE_BUILD_TYPE=Release"
  ] ++ (if cudaSupport then [
    "-DCUDA_PROPAGATE_HOST_FLAGS=off"
  ] else [
    "-DETHASHCUDA=OFF" # on by default
  ]);

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    cli11
    boost
    opencl-headers
    mesa
    ethash
    opencl-info
    ocl-icd
    openssl
    jsoncpp
  ] ++ lib.optionals cudaSupport [
    cudatoolkit
  ];

  patches = [
    # global context library is separated from libethash
    ./add-global-context.patch
  ];

  preConfigure = ''
    substituteInPlace libpoolprotocols/CMakeLists.txt --replace _static ""
  '';

  postInstall = ''
    wrapProgram $out/bin/ethminer --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
  '';

  meta = with lib; {
    description = "Ethereum miner with OpenCL${lib.optionalString cudaSupport ", CUDA"} and stratum support";
    homepage = "https://github.com/ethereum-mining/ethminer";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ atemu ];
    license = licenses.gpl3Only;
  };
}
