{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  opencl-headers,
  cmake,
  jsoncpp,
  boost16x,
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
  version = "0.19.0";

  src =
    fetchFromGitHub {
      owner = "ethereum-mining";
      repo = "ethminer";
      rev = "v${version}";
      sha256 = "1kyff3vx2r4hjpqah9qk99z6dwz7nsnbnhhl6a76mdhjmgp1q646";
      fetchSubmodules = true;
    };

  patches = [
    # global context library is separated from libethash
    ./add-global-context.patch

    # CUDA 11 no longer support SM30
    (fetchpatch {
      url = "https://github.com/ethereum-mining/ethminer/commit/dae359dff28f376d4ce7ddfbd651dcd34d6dad8f.patch";
      hash = "sha256-CJGKc0rXOcKDX1u5VBzc8gyBi1Me9CNATfQzKViqtAA=";
    })
  ];

  postPatch = ''
    sed -i 's/_lib_static//' libpoolprotocols/CMakeLists.txt
  '';

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
    boost16x # 1.7x support is broken, see https://github.com/ethereum-mining/ethminer/issues/2393
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
