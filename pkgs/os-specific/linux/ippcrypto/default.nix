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
  pname = "ippcrypto";
  version = "ippcp_2020u3";
  src = fetchFromGitHub {
    owner = "sbellem";
    repo = "linux-sgx";
    rev = "68fed00c67532cf5be7df8dac5f9d13b3c25e9d8";
    sha256 = "08a6y35s3rlvhcbd8zxqkw7d5vknb5b3mw0wa1wis6y7av5pskx2";
    fetchSubmodules = true;
  };
  buildInputs = [
    binutils
    autoconf
    automake
    libtool
    ocaml
    ocamlPackages.ocamlbuild
    file
    cmake
    gnum4
    openssl
    gcc
    gnumake
    texinfo
    bison
    flex
    perl
    python3
    git
    nasm
  ];
  dontConfigure = true;
  # sgx expects binutils to be under /usr/local/bin by default
  preBuild = ''
    export BINUTILS_DIR=$binutils/bin
    '';
  buildPhase = ''
    runHook preBuild

    cd external/ippcp_internal/
    make
    make MITIGATION-CVE-2020-0551=LOAD
    make clean
    make MITIGATION-CVE-2020-0551=CF

    runHook postBuild
    '';
  postBuild = ''
    mkdir -p $out
    cp -r ./lib $out/lib
    cp -r ./inc $out/inc
    cp -r ./license $out/license
    ls -l ./inc/
  '';
  dontInstall = true;
  dontFixup = true;

  meta = with lib; {
    description = "Intel IPP Crypto library for SGX";
    homepage = "https://github.com/intel/linux-sgx";
    maintainers = [ maintainers.sbellem ];
    platforms = platforms.linux;
    license = with licenses; [ asl20 bsd3 ];
  };
}
