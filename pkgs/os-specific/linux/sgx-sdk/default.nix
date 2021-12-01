{ lib
, stdenv
, fetchpatch
, fetchurl
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
    rev = "0cea078f17a24fb807e706409972d77f7a958db9";
    sha256 = "1cr2mkk459s270ng0yddgcryi0zc3dfmg9rmdrdh9mhy2mc1kx0g";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      name = "replace-bin-cp-with-cp.patch";
      url = "https://github.com/intel/linux-sgx/commit/e0db5291d46d1c124980719d63829d65f89cf2c7.patch";
      sha256 = "0xwlpm1r4rl4anfhjkr6fgz0gcyhr0ng46fv8iw9hfsh891yqb7z";
    })
    (fetchpatch {
      name = "sgx_ippcp.h.patch";
      url = "https://github.com/intel/linux-sgx/commit/e5929083f8161a8e7404afc0577936003fbb9d0b.patch";
      sha256 = "12bgs9rxlq82hn5prl9qz2r4mwypink8hzdz4cki4k4cmkw961f5";
    })
  ];
  postPatch = ''
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
  buildPhase = let
    ipp-crypto-no_mitigation = callPackage (import ./ipp-crypto.nix) {};

    sgx-asm-pp = "python ${src}/build-scripts/sgx-asm-pp.py --assembler=nasm";

    nasm-load = writeShellScript "nasm-load" "${sgx-asm-pp} --MITIGATION-CVE-2020-0551=LOAD $@";
    ipp-crypto-cve_2020_0551_load = callPackage (import ./ipp-crypto.nix) {
      extraCmakeFlags = [ "-DCMAKE_ASM_NASM_COMPILER=${nasm-load}" ];
    };

    nasm-cf = writeShellScript "nasm-cf" "${sgx-asm-pp} --MITIGATION-CVE-2020-0551=CF $@";
    ipp-crypto-cve_2020_0551_cf = callPackage (import ./ipp-crypto.nix) {
      extraCmakeFlags = [ "-DCMAKE_ASM_NASM_COMPILER=${nasm-cf}" ];
    };
  in ''
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
