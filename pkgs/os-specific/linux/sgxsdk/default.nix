{ lib,
  stdenvNoCC,
  fetchurl,
  fetchFromGitHub,
  autoconf,
  automake,
  binutils,
  bison,
  cmake,
  file,
  flex,
  gcc,
  git,
  gnumake,
  gnum4,
  libtool,
  nasm,
  ocaml,
  ocamlPackages,
  openssl,
  perl,
  python3,
  texinfo
}:

stdenvNoCC.mkDerivation {
  pname = "sgxsdk";
  version = "2.13.3";
  src = fetchFromGitHub {
    owner = "sbellem";
    repo = "linux-sgx";
    rev = "68fed00c67532cf5be7df8dac5f9d13b3c25e9d8";
    sha256 = "08a6y35s3rlvhcbd8zxqkw7d5vknb5b3mw0wa1wis6y7av5pskx2";
    fetchSubmodules = true;
  };
  dontConfigure = true;
  preBuild = ''
    export BINUTILS_DIR=$binutils/bin
    '';
  buildInputs = [
    autoconf
    automake
    binutils
    bison
    cmake
    file
    flex
    gcc
    git
    gnumake
    gnum4
    libtool
    ocaml
    ocamlPackages.ocamlbuild
    openssl
    perl
    python3
    texinfo
    nasm
  ];
  buildPhase = ''
    runHook preBuild

    cd external/ippcp_internal/
    make
    make clean
    make MITIGATION-CVE-2020-0551=LOAD
    make clean
    make MITIGATION-CVE-2020-0551=CF
    cd ../..

    make sdk_install_pkg

    runHook postBuild
    '';
  postBuild = ''
    echo -e 'no\n'$out | ./linux/installer/bin/sgx_linux_x64_sdk_*.bin
    '';
  dontInstall = true;
  dontFixup = true;

  meta = with lib; {
    description = "Intel SGX SDK for Linux built with IPP Crypto Library";
    homepage = "https://github.com/intel/linux-sgx";
    maintainers = [ maintainers.sbellem ];
    platforms = platforms.linux;
    license = with licenses; [ bsd3 ];
  };
}
