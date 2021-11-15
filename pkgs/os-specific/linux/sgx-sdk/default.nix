{ lib
, stdenv
, fetchFromGitHub
, callPackage
, autoconf
, automake
, binutils
, cmake
, file
, gdb
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
, writeShellScript
, writeText
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
      header "Setting up IPP crypto build artifacts"

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

    installDir=$TMPDIR
    ./linux/installer/bin/sgx_linux_x64_sdk_*.bin -prefix $installDir
    installDir=$installDir/sgxsdk

    header "Move files created by installer"

    mkdir -p $out/bin
    pushd $out

    mv $installDir/bin/sgx-gdb $out/bin
    mkdir $out/bin/x64
    for file in $installDir/bin/x64/*; do
      mv $file bin/
      ln -sr bin/$(basename $file) bin/x64/
    done
    rmdir $installDir/bin/{x64,}

    # Move `lib64` to `lib` and symlink `lib64`
    mv $installDir/lib64 lib
    ln -s lib/ lib64

    mv $installDir/include/ .

    mkdir -p share/
    mv $installDir/{SampleCode,licenses} share/

    mkdir -p share/bin
    mv $installDir/{environment,buildenv.mk} share/bin/
    ln -s share/bin/{environment,buildenv.mk} .

    # pkgconfig should go to lib/
    mv $installDir/pkgconfig lib/
    ln -s lib/pkgconfig/ .

    # Also create the `sdk_libs` for compat. All the files
    # link to libraries in `lib64/`, we shouldn't link the entire
    # directory, however, as there seems to be some ambiguity between
    # SDK and PSW libraries.
    mkdir sdk_libs/
    for file in $installDir/sdk_libs/*; do
      ln -sr lib/$(basename $file) sdk_libs/
      rm $file
    done
    rmdir $installDir/sdk_libs

    # No uninstall script required
    rm $installDir/uninstall.sh

    # Create an `sgxsdk` symlink which points to `$out` for compat
    ln -sr . sgxsdk

    # Make sure we didn't forget any files
    rmdir $installDir || (echo "Error: The directory $installDir still contains unhandled files: $(ls -A $installDir)" >&2 && exit 1)

    popd

    runHook postInstall
  '';


  preFixup = ''
    header "Strip sgxsdk prefix"
    for path in "$out/share/bin/environment" "$out/bin/sgx-gdb"; do
      substituteInPlace $path --replace "$TMPDIR/sgxsdk" "$out"
    done

    header "Fixing pkg-config files"
    sed -i "s|prefix=.*|prefix=$out|g" $out/lib/pkgconfig/*.pc

    header "Fixing SGX_SDK default in samples"
    substituteInPlace $out/share/SampleCode/LocalAttestation/buildenv.mk \
      --replace '/opt/intel/sgxsdk' "$out"
    for file in $out/share/SampleCode/*/Makefile; do
      substituteInPlace $file \
        --replace '/opt/intel/sgxsdk' "$out" \
        --replace '$(SGX_SDK)/buildenv.mk' "$out/share/bin/buildenv.mk"
    done

    header "Fixing BINUTILS_DIR in buildenv.mk"
    substituteInPlace $out/share/bin/buildenv.mk \
      --replace 'BINUTILS_DIR ?= /usr/local/bin' \
                'BINUTILS_DIR ?= ${BINUTILS_DIR}'

    header "Fixing GDB path in bin/sgx-gdb"
    substituteInPlace $out/bin/sgx-gdb --replace '/usr/local/bin/gdb' '${gdb}/bin/gdb'
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    # Make sure all symlinks are valid
    output=$(find "$out" -type l -exec test ! -e {} \; -print)
    if [[ -n "$output" ]]; then
      echo "Broken symlinks:"
      echo "$output"
      exit 1
    fi

    runHook postInstallCheck
  '';

  setupHook = writeText "setup-hook.sh" ''
    sgxsdk() {
        export SGX_SDK=@out@
    }

    postHooks+=(sgxsdk)
  '';

  passthru.tests = callPackage ./samples.nix { };

  meta = with lib; {
    description = "Intel SGX SDK for Linux built with IPP Crypto Library";
    homepage = "https://github.com/intel/linux-sgx";
    maintainers = with maintainers; [ sbellem arturcygan veehaitch ];
    platforms = [ "x86_64-linux" ];
    license = with licenses; [ bsd3 ];
  };
}
