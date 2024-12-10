{
  stdenv,
  lib,
  fetchurl,
  cmake,
  coreutils,
  curl,
  file,
  makeWrapper,
  nixosTests,
  protobuf,
  python3,
  sgx-sdk,
  which,
  debug ? false,
}:
stdenv.mkDerivation rec {
  inherit (sgx-sdk)
    patches
    src
    version
    versionTag
    ;
  pname = "sgx-psw";

  postUnpack =
    let
      # Fetch the pre-built, Intel-signed Architectural Enclaves (AE). They help
      # run user application enclaves, verify launch policies, produce remote
      # attestation quotes, and do platform certification.
      ae.prebuilt = fetchurl {
        url = "https://download.01.org/intel-sgx/sgx-linux/${versionTag}/prebuilt_ae_${versionTag}.tar.gz";
        hash = "sha256-IGV9VEwY/cQBV4Vz2sps4JgRweWRl/l08ocb9P4SH8Q=";
      };
      # Also include the Data Center Attestation Primitives (DCAP) platform
      # enclaves.
      dcap = rec {
        version = "1.21";
        filename = "prebuilt_dcap_${version}.tar.gz";
        prebuilt = fetchurl {
          url = "https://download.01.org/intel-sgx/sgx-dcap/${version}/linux/${filename}";
          hash = "sha256-/PPD2MyNxoCwzNljIFcpkFvItXbyvymsJ7+Uf4IyZuk=";
        };
      };
    in
    sgx-sdk.postUnpack
    + ''
      # Make sure we use the correct version of prebuilt DCAP
      grep -q 'ae_file_name=${dcap.filename}' "$src/external/dcap_source/QuoteGeneration/download_prebuilt.sh" \
        || (echo "Could not find expected prebuilt DCAP ${dcap.filename} in linux-sgx source" >&2 && exit 1)

      tar -zxf ${ae.prebuilt}   -C $sourceRoot/
      tar -zxf ${dcap.prebuilt} -C $sourceRoot/external/dcap_source/QuoteGeneration/
    '';

  nativeBuildInputs = [
    cmake
    file
    makeWrapper
    python3
    sgx-sdk
    which
  ];

  buildInputs = [
    curl
    protobuf
  ];

  hardeningDisable =
    [
      # causes redefinition of _FORTIFY_SOURCE
      "fortify3"
    ]
    ++ lib.optionals debug [
      "fortify"
    ];

  postPatch = ''
    patchShebangs \
      linux/installer/bin/build-installpkg.sh \
      linux/installer/common/psw/createTarball.sh \
      linux/installer/common/psw/install.sh
  '';

  dontUseCmakeConfigure = true;

  buildFlags =
    [
      "psw_install_pkg"
    ]
    ++ lib.optionals debug [
      "DEBUG=1"
    ];

  installFlags = [
    "-C linux/installer/common/psw/output"
    "DESTDIR=$(TMPDIR)/install"
  ];

  postInstall = ''
    installDir=$TMPDIR/install
    sgxPswDir=$installDir/opt/intel/sgxpsw

    mv $installDir/usr/lib64/ $out/lib/
    ln -sr $out/lib $out/lib64

    # Install udev rules to lib/udev/rules.d
    mv $sgxPswDir/udev/ $out/lib/

    # Install example AESM config
    mkdir $out/etc/
    mv $sgxPswDir/aesm/conf/aesmd.conf $out/etc/
    rmdir $sgxPswDir/aesm/conf/

    # Delete init service
    rm $sgxPswDir/aesm/aesmd.conf

    # Move systemd services
    mkdir -p $out/lib/systemd/system/
    mv $sgxPswDir/aesm/aesmd.service $out/lib/systemd/system/
    mv $sgxPswDir/remount-dev-exec.service $out/lib/systemd/system/

    # Move misc files
    mkdir $out/share/
    mv $sgxPswDir/licenses $out/share/

    # Remove unnecessary files
    rm $sgxPswDir/{cleanup.sh,startup.sh}
    rm -r $sgxPswDir/scripts

    # Move aesmd binaries/libraries/enclaves
    mv $sgxPswDir/aesm/ $out/

    # We absolutely MUST avoid stripping or patching these ".signed.so" SGX
    # enclaves. Stripping would change each enclave measurement (hash of the
    # binary).
    #
    # We're going to temporarily move these enclave libs to another directory
    # until after stripping/patching in the fixupPhase.
    mkdir $TMPDIR/enclaves
    mv $out/aesm/*.signed.so* $TMPDIR/enclaves

    mkdir $out/bin
    makeWrapper $out/aesm/aesm_service $out/bin/aesm_service \
      --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ protobuf ]}:$out/aesm \
      --chdir "$out/aesm"

    # Make sure we didn't forget to handle any files
    rmdir $sgxPswDir || (echo "Error: The directory $installDir still contains unhandled files: $(ls -A $installDir)" >&2 && exit 1)
  '';

  stripDebugList = [
    "lib"
    "bin"
    # Also strip binaries/libs in the `aesm` directory
    "aesm"
  ];

  postFixup = ''
    # Move the SGX enclaves back after everything else has been stripped.
    mv $TMPDIR/enclaves/*.signed.so* $out/aesm/
    rmdir $TMPDIR/enclaves

    # Fixup the aesmd systemd service
    #
    # Most—if not all—of those fixups are not relevant for NixOS as we have our own
    # NixOS module which is based on those files without relying on them. Still, it
    # is helpful to have properly patched versions for non-NixOS distributions.
    echo "Fixing aesmd.service"
    substituteInPlace $out/lib/systemd/system/aesmd.service \
      --replace-fail '@aesm_folder@' \
                     "$out/aesm" \
      --replace-fail 'Type=forking' \
                     'Type=simple' \
      --replace-fail "ExecStart=$out/aesm/aesm_service" \
                     "ExecStart=$out/bin/aesm_service --no-daemon"\
      --replace-fail "/bin/mkdir" \
                     "${coreutils}/bin/mkdir" \
      --replace-fail "/bin/chown" \
                     "${coreutils}/bin/chown" \
      --replace-fail "/bin/chmod" \
                     "${coreutils}/bin/chmod" \
      --replace-fail "/bin/kill" \
                     "${coreutils}/bin/kill"
  '';

  passthru.tests = {
    service = nixosTests.aesmd;
  };

  meta = {
    description = "Intel SGX Architectural Enclave Service Manager";
    homepage = "https://github.com/intel/linux-sgx";
    maintainers = with lib.maintainers; [
      phlip9
      veehaitch
      citadelcore
    ];
    platforms = [ "x86_64-linux" ];
    license = [ lib.licenses.bsd3 ];
  };
}
