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
  version = "2.13.3a0";
  src = fetchFromGitHub {
    owner = "sbellem";
    repo = "linux-sgx";
    rev = "e6036d6edb4371f2acc64c50b7cb51e9dfa439a4";
    sha256 = "0znallianv3lp3y62cfdgp8gacpw516qg8cjxhz8bj5lv5qghchk";
    fetchSubmodules = true;
  };
  dontConfigure = true;
  prePatch = ''
    patchShebangs ./linux/installer/bin/build-installpkg.sh
    patchShebangs ./linux/installer/common/sdk/createTarball.sh
    patchShebangs ./linux/installer/common/sdk/install.sh
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
  preBuild = ''
    export BINUTILS_DIR=$binutils/bin
    '';
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
    patchShebangs ./linux/installer/bin/sgx_linux_x64_sdk_*.bin
    '';
  installPhase = ''
    echo -e 'no\n'$out | ./linux/installer/bin/sgx_linux_x64_sdk_*.bin
    '';
  dontFixup = true;

  meta = with lib; {
    description = "Intel SGX SDK for Linux built with IPP Crypto Library";
    homepage = "https://github.com/intel/linux-sgx";
    maintainers = [ maintainers.sbellem ];
    platforms = platforms.linux;
    license = with licenses; [ bsd3 ];
  };
}
