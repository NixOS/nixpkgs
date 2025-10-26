{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  cmake,
  coreutils,
  curl,
  file,
  git,
  makeWrapper,
  nixosTests,
  protobuf,
  python3,
  ocaml,
  ocamlPackages,
  which,
  debug ? false,
}:
stdenv.mkDerivation rec {
  pname = "sgx-psw";
  # Version as given in se_version.h
  version = "2.25.100.3";
  # Version as used in the Git tag
  versionTag = "2.25";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "linux-sgx";
    rev = "sgx_${versionTag}";
    hash = "sha256-RR+vFTd9ZM6XUn3KgQeUM+xoj1Ava4zQzFYA/nfXyaw=";
    fetchSubmodules = true;
  };

  # Extract Intel-provided, pre-built enclaves and libs.
  postUnpack =
    let
      # Fetch the pre-built, Intel-signed Architectural Enclaves (AE). They help
      # run user application enclaves, verify launch policies, produce remote
      # attestation quotes, and do platform certification.
      ae.prebuilt = fetchurl {
        url = "https://download.01.org/intel-sgx/sgx-linux/${versionTag}/prebuilt_ae_${versionTag}.tar.gz";
        hash = "sha256-Hlh96rYOyml2y50d8ASKz6U97Fl0hbGYECeZiG9nMSQ=";
      };

      # Pre-built ipp-crypto with mitigations.
      optlib.prebuilt = fetchurl {
        url = "https://download.01.org/intel-sgx/sgx-linux/${versionTag}/optimized_libs_${versionTag}.tar.gz";
        hash = "sha256-7mDTaLtpOQLHQ6Fv+FWJ2k/veJZPXIcuj7kOdRtRqhg=";
      };

      # Fetch the Data Center Attestation Primitives (DCAP) platform enclaves
      # and pre-built sgxssl.
      dcap = rec {
        version = "1.22";
        filename = "prebuilt_dcap_${version}.tar.gz";
        prebuilt = fetchurl {
          url = "https://download.01.org/intel-sgx/sgx-dcap/${version}/linux/${filename}";
          hash = "sha256-RTpJQ6epoAN8YQXSJUjJQ5mPaQIiQpStTWFsnspjjDQ=";
        };
      };
    in
    ''
      # Make sure this is the right version of linux-sgx
      grep -q '"${version}"' "$src/common/inc/internal/se_version.h" \
        || (echo "Could not find expected version ${version} in linux-sgx source" >&2 && exit 1)

      tar -xzvf ${ae.prebuilt}     -C $sourceRoot/
      tar -xzvf ${optlib.prebuilt} -C $sourceRoot/

      # Make sure we use the correct version of prebuilt DCAP
      grep -q 'ae_file_name=${dcap.filename}' "$src/external/dcap_source/QuoteGeneration/download_prebuilt.sh" \
        || (echo "Could not find expected prebuilt DCAP ${dcap.filename} in linux-sgx source" >&2 && exit 1)

      tar -xzvf ${dcap.prebuilt} -C $sourceRoot/external/dcap_source ./prebuilt/
      tar -xzvf ${dcap.prebuilt} -C $sourceRoot/external/dcap_source/QuoteGeneration ./psw/
    '';

  patches = [
    # There's a `make preparation` step that downloads some prebuilt binaries
    # and applies some patches to the in-repo git submodules. This patch removes
    # the parts that download things, since we can't do that inside the sandbox.
    ./disable-downloads.patch

    # This patch disables mtime in bundled zip file for reproducible builds.
    #
    # Context: The `aesm_service` binary depends on a vendored library called
    # `CppMicroServices`. At build time, this lib creates and then bundles
    # service resources into a zip file and then embeds this zip into the
    # binary. Without changes, the `aesm_service` will be different after every
    # build because the embedded zip file contents have different modified times.
    ./cppmicroservices-no-mtime.patch
  ];

  postPatch =
    let
      # The base directories we want to copy headers from. The exact headers are
      # parsed from <linux/installer/common/sdk/BOMs/sdk_base.txt>
      bomDirsToCopyFrom = builtins.concatStringsSep "|" [
        "common/"
        "external/dcap_source/"
        "external/ippcp_internal/"
        "external/sgx-emm/"
        "psw/"
        "sdk/tlibcxx/"
      ];
    in
    ''
      patchShebangs \
        external/sgx-emm/create_symlink.sh \
        linux/installer/bin/build-installpkg.sh \
        linux/installer/common/psw/createTarball.sh \
        linux/installer/common/psw/install.sh

      # Run sgx-sdk preparation step
      make preparation

      # Build a fake SGX_SDK directory. Normally sgx-psw depends on first building
      # all of sgx-sdk, however we can actually build them independently by just
      # copying a few header files and building `sgx_edger8r` separately.
      mkdir .sgxsdk
      export SGX_SDK="$(readlink -f .sgxsdk)"

      # Parse the BOM for the headers we need, then copy them into SGX_SDK
      # Each line in the BOM.txt looks like:
      # <deliverydir>/...\t<installdir>/package/...\t....
      # TODO(phlip9): hardlink?
      sed -n -r 's:^<deliverydir>/(${bomDirsToCopyFrom})(\S+)\s<installdir>/package/(\S+)\s.*$:\1\2\n.sgxsdk/\3:p' \
        < linux/installer/common/sdk/BOMs/sdk_base.txt \
        | xargs --max-args=2 install -v -D
    '';

  nativeBuildInputs = [
    cmake
    file
    git
    makeWrapper
    ocaml
    ocamlPackages.ocamlbuild
    python3
    which
  ];

  buildInputs = [
    curl
    protobuf
  ];

  dontUseCmakeConfigure = true;

  preBuild = ''
    # Build `sgx_edger8r`, the enclave .edl -> .h file codegen tool.
    # Then place it in `$SGX_SDK/bin` and `$SGX_SDK/bin/x64`.
    make -C sdk/edger8r/linux
    mkdir -p $SGX_SDK/bin/x64
    sgx_edger8r_bin="$(readlink -f build/linux/sgx_edger8r)"
    ln -s $sgx_edger8r_bin $SGX_SDK/bin/
    ln -s $sgx_edger8r_bin $SGX_SDK/bin/x64/

    # Add this so we can link against libsgx_urts.
    build_dir="$(readlink -f build/linux)"
    ln -s $build_dir $SGX_SDK/lib
    ln -s $build_dir $SGX_SDK/lib64
  '';

  buildFlags = [ "psw_install_pkg" ] ++ lib.optionals debug [ "DEBUG=1" ];

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
