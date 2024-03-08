{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoconf
, automake
, binutils
, callPackage
, cmake
, file
, gdb
, git
, libtool
, linkFarmFromDrvs
, ocaml
, ocamlPackages
, openssl
, perl
, python3
, texinfo
, validatePkgConfig
, writeShellApplication
, writeShellScript
, writeText
, debug ? false
}:
stdenv.mkDerivation rec {
  pname = "sgx-sdk";
  # Version as given in se_version.h
  version = "2.21.100.1";
  # Version as used in the Git tag
  versionTag = "2.21";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "linux-sgx";
    rev = "sgx_${versionTag}";
    hash = "sha256-Yo2G0H0XUI2p9W7lDRLkFHw2t8X1220brGohQJ0r2WY=";
    fetchSubmodules = true;
  };

  postUnpack = ''
    # Make sure this is the right version of linux-sgx
    grep -q '"${version}"' "$src/common/inc/internal/se_version.h" \
      || (echo "Could not find expected version ${version} in linux-sgx source" >&2 && exit 1)
  '';

  patches = [
    # Fix missing pthread_compat.h, see https://github.com/intel/linux-sgx/pull/784
    (fetchpatch {
      url = "https://github.com/intel/linux-sgx/commit/254b58f922a6bd49c308a4f47f05f525305bd760.patch";
      sha256 = "sha256-sHU++K7NJ+PdITx3y0PwstA9MVh10rj2vrLn01N9F4w=";
    })
  ];

  # There's a `make preparation` step that downloads some prebuilt binaries and
  # applies some patches to the in-repo git submodules. We can't just run it,
  # since it downloads things, so this step just extracts the patching steps.
  postPatch = ''
    patchShebangs linux/installer/bin/build-installpkg.sh \
      linux/installer/common/sdk/createTarball.sh \
      linux/installer/common/sdk/install.sh \
      external/sgx-emm/create_symlink.sh

    echo "Running 'make preparation' but without download steps"

    # Seems to download something. Build currently uses ipp-crypto and not
    # sgxssl so probably not an issue.
    # $ ./external/dcap_source/QuoteVerification/prepare_sgxssl.sh nobuild

    pushd external/openmp/openmp_code
      git apply ../0001-Enable-OpenMP-in-SGX.patch >/dev/null 2>&1 \
        || git apply ../0001-Enable-OpenMP-in-SGX.patch --check -R
    popd

    pushd external/protobuf/protobuf_code
      git apply ../sgx_protobuf.patch >/dev/null 2>&1 \
        || git apply ../sgx_protobuf.patch --check -R
    popd

    ./external/sgx-emm/create_symlink.sh
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
      echo "Setting up IPP crypto build artifacts"

      pushd 'external/ippcp_internal'

      cp -r ${ipp-crypto-no_mitigation}/include/. inc/

      install -D -m a+rw ${ipp-crypto-no_mitigation}/lib/intel64/libippcp.a \
        lib/linux/intel64/no_mitigation/libippcp.a
      install -D -m a+rw ${ipp-crypto-cve_2020_0551_load}/lib/intel64/libippcp.a \
        lib/linux/intel64/cve_2020_0551_load/libippcp.a
      install -D -m a+rw ${ipp-crypto-cve_2020_0551_cf}/lib/intel64/libippcp.a \
        lib/linux/intel64/cve_2020_0551_cf/libippcp.a

      rm inc/ippcp.h
      patch ${ipp-crypto-no_mitigation}/include/ippcp.h -i inc/ippcp21u7.patch -o inc/ippcp.h

      install -D ${ipp-crypto-no_mitigation.src}/LICENSE license/LICENSE

      popd
    '';

  buildFlags = [
    "sdk_install_pkg"
  ] ++ lib.optionals debug [
    "DEBUG=1"
  ];

  postBuild = ''
    patchShebangs linux/installer/bin/sgx_linux_x64_sdk_${version}.bin
  '';

  installPhase = ''
    runHook preInstall

    installDir=$TMPDIR
    ./linux/installer/bin/sgx_linux_x64_sdk_${version}.bin -prefix $installDir
    installDir=$installDir/sgxsdk

    echo "Move files created by installer"

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

    # Fixup the symlinks for libsgx_urts.so.* -> libsgx_urts.so
    for file in lib/libsgx_urts.so.*; do
      ln -srf lib/libsgx_urts.so $file
    done

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
    echo "Strip sgxsdk prefix"
    for path in "$out/share/bin/environment" "$out/bin/sgx-gdb"; do
      substituteInPlace $path --replace "$TMPDIR/sgxsdk" "$out"
    done

    echo "Fixing pkg-config files"
    sed -i "s|prefix=.*|prefix=$out|g" $out/lib/pkgconfig/*.pc

    echo "Fixing SGX_SDK default in samples"
    substituteInPlace $out/share/SampleCode/LocalAttestation/buildenv.mk \
      --replace '/opt/intel/sgxsdk' "$out"
    for file in $out/share/SampleCode/*/Makefile; do
      substituteInPlace $file \
        --replace '/opt/intel/sgxsdk' "$out"
    done

    echo "Fixing BINUTILS_DIR in buildenv.mk"
    substituteInPlace $out/share/bin/buildenv.mk \
      --replace 'BINUTILS_DIR ?= /usr/local/bin' \
                'BINUTILS_DIR ?= ${BINUTILS_DIR}'

    echo "Fixing GDB path in bin/sgx-gdb"
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

  passthru.tests = callPackage ../samples { sgxMode = "SIM"; };

  # Run tests in SGX hardware mode on an SGX-enabled machine
  # $(nix-build -A sgx-sdk.runTestsHW)/bin/run-tests-hw
  passthru.runTestsHW =
    let
      testsHW = lib.filterAttrs (_: v: v ? "name") (callPackage ../samples { sgxMode = "HW"; });
      testsHWLinked = linkFarmFromDrvs "sgx-samples-hw-bundle" (lib.attrValues testsHW);
    in
    writeShellApplication {
      name = "run-tests-hw";
      text = ''
        for test in ${testsHWLinked}/*; do
          printf '*** Running test %s ***\n\n' "$(basename "$test")"
          printf 'a\n' | "$test/bin/app"
          printf '\n'
        done
      '';
    };

  meta = with lib; {
    description = "Intel SGX SDK for Linux built with IPP Crypto Library";
    homepage = "https://github.com/intel/linux-sgx";
    maintainers = with maintainers; [ sbellem arturcygan veehaitch ];
    platforms = [ "x86_64-linux" ];
    license = with licenses; [ bsd3 ];
  };
}
