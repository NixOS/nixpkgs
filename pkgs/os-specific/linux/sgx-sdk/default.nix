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
, validatePkgConfig
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

    patchShebangs linux/installer/bin/build-installpkg.sh \
      linux/installer/common/sdk/createTarball.sh \
      linux/installer/common/sdk/install.sh
  '';

  # We need `cmake` as a build input but don't use it to kick off the build phase
  dontUseCmakeConfigure = true;

  # SDK built with stackprotector produces broken enclaves which crash at runtime.
  # Disable all to be safe, SDK build configures compiler mitigations manually.
  hardeningDisable = [ "all" ];

  nativeBuildInputs = [
    autoconf
    automake
    cmake
    file
    git
    ncurses
    ocaml
    ocamlPackages.ocamlbuild
    perl
    python3
    texinfo
    validatePkgConfig
  ];

  buildInputs = [
    libtool
    openssl
  ];

  BINUTILS_DIR = "${binutils}/bin";

  # Build external/ippcp_internal first. The Makefile is rewritten to make the
  # build faster by splitting different versions of ipp-crypto builds and to
  # avoid patching the Makefile for reproducibility issues.
  preBuild =
    let
      ipp-crypto-no_mitigation = callPackage ./ipp-crypto.nix { };

      sgx-asm-pp = "python ${src}/build-scripts/sgx-asm-pp.py --assembler=nasm";

      nasm-load = writeShellScript "nasm-load" "${sgx-asm-pp} --MITIGATION-CVE-2020-0551=LOAD $@";
      ipp-crypto-cve_2020_0551_load = callPackage ./ipp-crypto.nix {
        extraCmakeFlags = [ "-DCMAKE_ASM_NASM_COMPILER=${nasm-load}" ];
      };

      nasm-cf = writeShellScript "nasm-cf" "${sgx-asm-pp} --MITIGATION-CVE-2020-0551=CF $@";
      ipp-crypto-cve_2020_0551_cf = callPackage ./ipp-crypto.nix {
        extraCmakeFlags = [ "-DCMAKE_ASM_NASM_COMPILER=${nasm-cf}" ];
      };
    in
    ''
      pushd 'external/ippcp_internal'

      install ${ipp-crypto-no_mitigation}/include/* inc/

      install -D -m a+rw ${ipp-crypto-no_mitigation}/lib/intel64/libippcp.a \
        lib/linux/intel64/no_mitigation/libippcp.a
      install -D -m a+rw ${ipp-crypto-cve_2020_0551_load}/lib/intel64/libippcp.a \
        lib/linux/intel64/cve_2020_0551_load/libippcp.a
      install -D -m a+rw ${ipp-crypto-cve_2020_0551_cf}/lib/intel64/libippcp.a \
        lib/linux/intel64/cve_2020_0551_cf/libippcp.a

      rm inc/ippcp.h
      patch ${ipp-crypto-no_mitigation}/include/ippcp.h -i inc/ippcp20u3.patch -o inc/ippcp.h

      install -D ${ipp-crypto-no_mitigation.src}/LICENSE license/LICENSE

      popd
    '';

  buildFlags = [
    "sdk_install_pkg"
  ];

  postBuild = ''
    patchShebangs linux/installer/bin/sgx_linux_x64_sdk_*.bin
  '';

  installPhase = ''
    runHook preInstall

    ./linux/installer/bin/sgx_linux_x64_sdk_*.bin -prefix "$out"

    runHook postInstall
  '';

  preFixup = ''
    echo "Fixing pkg-config files"
    sed -i "s|prefix=.*|prefix=$out/sgxsdk|g" $out/sgxsdk/pkgconfig/*.pc
  '';

  doInstallCheck = true;
  installCheckInputs = [ which ];
  installCheckPhase = ''
    runHook preInstallCheck

    source $out/sgxsdk/environment
    cd SampleCode/SampleEnclave
    make SGX_MODE=SGX_SIM
    ./app

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Intel SGX SDK for Linux built with IPP Crypto Library";
    homepage = "https://github.com/intel/linux-sgx";
    maintainers = with maintainers; [ sbellem arturcygan ];
    platforms = [ "x86_64-linux" ];
    license = with licenses; [ bsd3 ];
  };
}
