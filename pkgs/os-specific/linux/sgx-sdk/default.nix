{ lib
, stdenv
, fetchFromGitHub
, callPackage
, autoconf
, automake
, binutils
, cmake
, file
, git
, libtool
, nasm
, ncurses
, ocaml
, ocamlPackages
, openssl
, perl
, python3
, texinfo
, which
, writeShellScript
}:

stdenv.mkDerivation rec {
  pname = "sgx-sdk";
  version = "2.14";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "linux-sgx";
    rev = "sgx_${version}";
    sha256 = "1cr2mkk459s270ng0yddgcryi0zc3dfmg9rmdrdh9mhy2mc1kx0g";
    fetchSubmodules = true;
  };

  postPatch = ''
    # https://github.com/intel/linux-sgx/pull/730
    substituteInPlace buildenv.mk --replace '/bin/cp' 'cp'

    # https://github.com/intel/linux-sgx/pull/752
    ln -s "$src/external/epid-sdk/ext/ipp/include/sgx_ippcp.h" \
          'external/ippcp_internal/inc/sgx_ippcp.h'

    patchShebangs ./linux/installer/bin/build-installpkg.sh \
      ./linux/installer/common/sdk/createTarball.sh \
      ./linux/installer/common/sdk/install.sh
  '';

  dontConfigure = true;

  # SDK built with stackprotector produces broken enclaves which crash at runtime.
  # Disable all to be safe, SDK build configures compiler mitigations manually.
  hardeningDisable = [ "all" ];

  nativeBuildInputs = [
    cmake
    git
    ocaml
    ocamlPackages.ocamlbuild
    perl
    python3
    texinfo
    nasm
    file
    ncurses
    autoconf
    automake
  ];

  buildInputs = [
    libtool
    openssl
  ];

  BINUTILS_DIR = "${binutils}/bin";

  # Build external/ippcp_internal first. The Makefile is rewritten to make the
  # build faster by splitting different versions of ipp-crypto builds and to
  # avoid patching the Makefile for reproducibility issues.
  buildPhase =
    let
      ipp-crypto-no_mitigation = callPackage (import ./ipp-crypto.nix) { };

      sgx-asm-pp = "python ${src}/build-scripts/sgx-asm-pp.py --assembler=nasm";

      nasm-load = writeShellScript "nasm-load" "${sgx-asm-pp} --MITIGATION-CVE-2020-0551=LOAD $@";
      ipp-crypto-cve_2020_0551_load = callPackage (import ./ipp-crypto.nix) {
        extraCmakeFlags = [ "-DCMAKE_ASM_NASM_COMPILER=${nasm-load}" ];
      };

      nasm-cf = writeShellScript "nasm-cf" "${sgx-asm-pp} --MITIGATION-CVE-2020-0551=CF $@";
      ipp-crypto-cve_2020_0551_cf = callPackage (import ./ipp-crypto.nix) {
        extraCmakeFlags = [ "-DCMAKE_ASM_NASM_COMPILER=${nasm-cf}" ];
      };
    in
    ''
      cd external/ippcp_internal

      mkdir -p lib/linux/intel64/no_mitigation
      cp ${ipp-crypto-no_mitigation}/lib/intel64/libippcp.a lib/linux/intel64/no_mitigation
      chmod a+w lib/linux/intel64/no_mitigation/libippcp.a
      cp ${ipp-crypto-no_mitigation}/include/* ./inc

      mkdir -p lib/linux/intel64/cve_2020_0551_load
      cp ${ipp-crypto-cve_2020_0551_load}/lib/intel64/libippcp.a lib/linux/intel64/cve_2020_0551_load
      chmod a+w lib/linux/intel64/cve_2020_0551_load/libippcp.a

      mkdir -p lib/linux/intel64/cve_2020_0551_cf
      cp ${ipp-crypto-cve_2020_0551_cf}/lib/intel64/libippcp.a lib/linux/intel64/cve_2020_0551_cf
      chmod a+w lib/linux/intel64/cve_2020_0551_cf/libippcp.a

      rm -f ./inc/ippcp.h
      patch ${ipp-crypto-no_mitigation}/include/ippcp.h -i ./inc/ippcp20u3.patch -o ./inc/ippcp.h

      mkdir -p license
      cp ${ipp-crypto-no_mitigation.src}/LICENSE ./license

      # Build the SDK installation package.
      cd ../..

      # Nix patches make so that $(SHELL) defaults to "sh" instead of "/bin/sh".
      # The build uses $(SHELL) as an argument to file -L which requires a path.
      make SHELL=$SHELL sdk_install_pkg

      runHook postBuild
    '';

  postBuild = ''
    patchShebangs ./linux/installer/bin/sgx_linux_x64_sdk_*.bin
  '';

  installPhase = ''
    echo -e 'no\n'$out | ./linux/installer/bin/sgx_linux_x64_sdk_*.bin
  '';

  dontFixup = true;

  doInstallCheck = true;
  installCheckInputs = [ which ];
  installCheckPhase = ''
    source $out/sgxsdk/environment
    cd SampleCode/SampleEnclave
    make SGX_MODE=SGX_SIM
    ./app
  '';

  meta = with lib; {
    description = "Intel SGX SDK for Linux built with IPP Crypto Library";
    homepage = "https://github.com/intel/linux-sgx";
    maintainers = with maintainers; [ sbellem arturcygan ];
    platforms = [ "x86_64-linux" ];
    license = with licenses; [ bsd3 ];
  };
}
