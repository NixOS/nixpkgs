{ stdenv, fetchFromGitHub, opencl-headers, cmake, jsoncpp, boost, makeWrapper,
  cudatoolkit, mesa, ethash, opencl-info, ocl-icd, openssl, pkg-config, cli11 }:

stdenv.mkDerivation rec {
  pname = "ethminer";
  version = "0.18.0-rc.0";

  src =
    fetchFromGitHub {
      owner = "ethereum-mining";
      repo = "ethminer";
      rev = "v${version}";
      sha256 = "0gwnwxahjfwr4d2aci7y3w206nc5ifssl28ildva98ys0d24wy7z";
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
    homepage = https://github.com/ethereum-mining/ethminer;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ nand0p ];
    license = licenses.gpl2;
  };

}
