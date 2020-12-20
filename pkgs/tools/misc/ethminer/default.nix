{
  clangStdenv,
  fetchFromGitHub,
  opencl-headers,
  cmake,
  jsoncpp,
  boost,
  makeWrapper,
  cudatoolkit,
  mesa,
  ethash,
  opencl-info,
  ocl-icd,
  openssl,
  pkg-config,
  cli11
}:

# Note that this requires clang < 9.0 to build, and currently
# clangStdenv provides clang 7.1 which satisfies the requirement.
let stdenv = clangStdenv;

in stdenv.mkDerivation rec {
  pname = "ethminer";
  version = "0.18.0";

  src =
    fetchFromGitHub {
      owner = "ethereum-mining";
      repo = "ethminer";
      rev = "v${version}";
      sha256 = "10b6s35axmx8kyzn2vid6l5nnzcaf4nkk7f5f7lg3cizv6lsj707";
      fetchSubmodules = true;
    };

  # NOTE: dbus is broken
  cmakeFlags = [
    "-DHUNTER_ENABLED=OFF"
    "-DETHASHCUDA=ON"
    "-DAPICORE=ON"
    "-DETHDBUS=OFF"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

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
    cudatoolkit
    ethash
    opencl-info
    ocl-icd
    openssl
    jsoncpp
  ];

  preConfigure = ''
    sed -i 's/_lib_static//' libpoolprotocols/CMakeLists.txt
  '';

  postInstall = ''
    wrapProgram $out/bin/ethminer --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
  '';

  meta = with stdenv.lib; {
    description = "Ethereum miner with OpenCL, CUDA and stratum support";
    homepage = "https://github.com/ethereum-mining/ethminer";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ nand0p ];
    license = licenses.gpl2;
  };
}
