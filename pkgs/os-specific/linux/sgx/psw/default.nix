{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  cmake,
  coreutils,
  curl,
  file,
  makeBinaryWrapper,
  nixosTests,
  protobuf,
  python3,
  ocaml,
  ocamlPackages,
  which,

  debug ? false,
}:

let
  # Version as given in se_version.h
  version = "2.30.101.1";
  # Version as used in the Git tag
  versionTag = "2.30.1";

  # The 2.30.1 patch release did not update the SDK submodule. On the next
  # normal release, remove these separate versions and use `version` and
  # `versionTag` for `sgx-sdk-runtime` again.
  sdkVersion = "2.30.100.1";
  sdkVersionTag = "2.30";

  # Pre-built Intel-signed Architectural Enclaves (AE). They help run user
  # application enclaves, verify launch policies, produce remote attestation
  # quotes, and do platform certification.
  ae = {
    # The 2.30.1 patch release reuses the 2.30 prebuilt enclaves. On the next
    # normal release, remove this separate version and use `versionTag` again.
    version = "2.30";
    prebuilt = fetchurl {
      url = "https://download.01.org/intel-sgx/sgx-linux/${ae.version}/prebuilt_ae_${ae.version}.tar.gz";
      hash = "sha256-Hcz1dtFJFj3LHfs35CQSObmyV4zC2PLzj42bvaLuylQ=";
    };
  };

  # DCAP (Data Center Attestation Primitives) platform enclaves and pre-built
  # sgxssl.
  dcap = {
    version = "1.27";
    filename = "prebuilt_dcap_${dcap.version}.tar.gz";

    # DCAP pre-built enclaves + sgxssl lib
    prebuilt = fetchurl {
      url = "https://download.01.org/intel-sgx/sgx-dcap/${dcap.version}/linux/${dcap.filename}";
      hash = "sha256-5zdrb2E3YC20Vs85YHDJ5/KHyM2VXI6xJGbOzxcFoeY=";
    };

    # DCAP repo
    src = fetchFromGitHub {
      owner = "intel";
      repo = "confidential-computing.tee.dcap";
      tag = "DCAP_${dcap.version}";
      hash = "sha256-ywONoNFkofnDFOnGwDjddi+nNfxJzQmE1f+s0XcWxjY=";
    };

    # DCAP QVL (Quote Verification Library) repo
    qvl.src = fetchFromGitHub {
      owner = "intel";
      repo = "confidential-computing.tee.dcap.qvl";
      tag = "v${dcap.version}";
      hash = "sha256-RkY3XQ+Ih5m/QPDK/2DDSHL83vxlR4Eedqu1mSut4MI=";
    };
  };

  # SGX "enclave memory management library" repo
  sgx-emm.src = fetchFromGitHub {
    owner = "intel";
    repo = "sgx-emm";
    rev = "bb3d852d9091458366fec397488aaeb8d52a2ad0";
    hash = "sha256-Z4dcSv4Wa4LrvZnr+PX+EQbacVjWrRupJKDYqXhOKj4=";
  };

  # Only build the untrusted host enclave runtime and edger8r needed for
  # sgx-psw/aesmd. Building the entire SDK takes like 30+ min, while this takes
  # 1 min.
  sgx-sdk-runtime = stdenv.mkDerivation {
    pname = "sgx-sdk-runtime";
    version = sdkVersion;

    src = fetchFromGitHub {
      owner = "intel";
      repo = "confidential-computing.sgx.sdk";
      tag = "sgx_${sdkVersionTag}";
      hash = "sha256-wbozHPlHOQ8lgc2hDWPML+cKp+WlupE7Wtjnurc23tM=";
    };

    postUnpack = ''
      mkdir -p $sourceRoot/external/sgx-emm/emm_src
      cp -R --no-preserve=mode ${sgx-emm.src}/. $sourceRoot/external/sgx-emm/emm_src/

      mkdir -p $sourceRoot/prebuilt/dcap
      tar -xzf ${dcap.prebuilt} -C $sourceRoot/prebuilt/dcap \
        --strip-components=1 prebuilt/openssl
    '';

    postPatch = ''
      patchShebangs external/sgx-emm/create_symlink.sh
      external/sgx-emm/create_symlink.sh
    '';

    nativeBuildInputs = [
      ocaml
      ocamlPackages.ocamlbuild
    ];

    dontConfigure = true;

    # Build:
    # - `sgx_edger8r` enclave .edl -> .h file codegen tool
    # - uRTS untrusted enclave runtime libs
    buildPhase = ''
      runHook preBuild

      make -C sdk/edger8r/linux
      make -C enclave_runtime ${lib.optionalString debug "DEBUG=1"}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm755 build/linux/sgx_edger8r $out/bin/x64/sgx_edger8r
      ln -s x64/sgx_edger8r $out/bin/sgx_edger8r

      mkdir -p $out/include $out/lib
      cp -LR common/inc/. $out/include/
      install -Dm644 enclave_runtime/enclave_common/sgx_enclave_common.h $out/include/sgx_enclave_common.h
      cp -a build/linux/libsgx_enclave_common.so* $out/lib/
      cp -a build/linux/libsgx_urts.so* $out/lib/
      install -Dm755 build/linux/liburts_internal.so $out/lib/liburts_internal.so
      ln -s lib $out/lib64

      substitute common/buildenv.mk $out/buildenv.mk \
        --replace-fail '@SDK_PKG_VERSION@' '${sdkVersion}'

      runHook postInstall
    '';
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "sgx-psw";
  inherit version versionTag;

  src = fetchFromGitHub {
    owner = "intel";
    repo = "confidential-computing.sgx";
    tag = "sgx_${finalAttrs.versionTag}";
    hash = "sha256-xmCVKbLkLZLizXstvm9QEbk8PKre6rsg6lExeDfkz8M=";
  };

  # Extract Intel-provided pre-built enclaves, libs, and subrepos
  postUnpack = ''
    mkdir -p \
      $sourceRoot/sdk \
      $sourceRoot/external/dcap_source \
      $sourceRoot/external/dcap_source/QuoteVerification/QVL \
      $sourceRoot/prebuilt/dcap

    cp -R --no-preserve=mode ${sgx-sdk-runtime.src}/. $sourceRoot/sdk/
    cp -R --no-preserve=mode ${dcap.src}/. $sourceRoot/external/dcap_source/
    cp -R --no-preserve=mode ${dcap.qvl.src}/. $sourceRoot/external/dcap_source/QuoteVerification/QVL/

    tar -xzf ${dcap.prebuilt} -C $sourceRoot/external/dcap_source prebuilt/
    tar -xzf ${dcap.prebuilt} -C $sourceRoot/external/dcap_source/QuoteGeneration psw/
    tar -xzf ${dcap.prebuilt} -C $sourceRoot/prebuilt/dcap --strip-components=1 prebuilt/openssl

    tar -xzf ${ae.prebuilt} -C $sourceRoot/

    # Make sure we have the repo version matches our package version.
    grep -q '"${finalAttrs.version}"' "$sourceRoot/common/inc/internal/se_version.h" \
      || (echo "Could not find expected version ${finalAttrs.version}" >&2 && exit 1)

    # Make sure we have right DCAP version
    grep -qE '(dcap_version=${dcap.version}|ae_file_name=${dcap.filename})' \
      "$sourceRoot/external/dcap_source/QuoteGeneration/download_prebuilt.sh" \
      || (echo "Could not find expected prebuilt DCAP ${dcap.filename}" >&2 && exit 1)
  '';

  patches = [
    # This patch disables mtime in bundled zip file for reproducible builds.
    #
    # Context: The `aesm_service` binary depends on a vendored library called
    # `CppMicroServices`. At build time, this lib creates and then bundles
    # service resources into a zip file and then embeds this zip into the
    # binary. Without changes, the `aesm_service` will be different after every
    # build because the embedded zip file contents have different modified times.
    ./cppmicroservices-no-mtime.patch

    # Add `#include <cstdint>` to CppMicroServices headers that GCC 15 needs
    ./cppmicroservices-compat.patch
  ];

  nativeBuildInputs = [
    cmake
    file
    makeBinaryWrapper
    python3
    which
  ];

  buildInputs = [
    curl
    protobuf
  ];

  dontUseCmakeConfigure = true;

  makeFlags = [
    "-C"
    "psw"
  ];
  buildFlags = lib.optionals debug [ "DEBUG=1" ];

  SGX_SDK = sgx-sdk-runtime;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{aesm/bundles,etc,lib,share/licenses}

    cp -a $SGX_SDK/lib/libsgx_enclave_common.so* $out/lib/
    cp -a $SGX_SDK/lib/libsgx_urts.so* $out/lib/
    cp -a build/linux/libsgx_quote_ex.so* $out/lib/
    install -m755 build/linux/libsgx_uae_service.so $out/lib/
    ln -sr $out/lib $out/lib64

    # Avoid including the sgx-sdk-runtime in the final closure
    urts=$(readlink -f $out/lib/libsgx_urts.so)
    chmod u+w $urts
    patchelf --set-rpath \
      "$(patchelf --print-rpath $urts | sed "s#$SGX_SDK/lib#$out/lib#")" \
      $urts

    # Assemble the AESM service
    install -m755 \
      build/linux/aesm_service \
      build/linux/libCppMicroServices.so.4.0.0 \
      build/linux/libipc.so \
      build/linux/liboal.so \
      build/linux/libutils.so \
      $out/aesm/
    install -m755 \
      build/linux/bundles/libecdsa_quote_service_bundle.so \
      build/linux/bundles/liblinux_network_service_bundle.so \
      build/linux/bundles/libpce_service_bundle.so \
      build/linux/bundles/libquote_ex_service_bundle.so \
      $out/aesm/bundles/

    install -m755 $SGX_SDK/lib/liburts_internal.so $out/aesm/
    ln -s liburts_internal.so $out/aesm/libsgx_urts.so.2

    # Copy DCAP libs
    dcapBuild=external/dcap_source/QuoteGeneration/build/linux
    cp -a $dcapBuild/libsgx_default_qcnl_wrapper.so* $out/aesm/
    install -m755 $dcapBuild/libsgx_pce_logic.so $out/aesm/libsgx_pce_logic.so.1
    install -m755 $dcapBuild/libsgx_qe3_logic.so $out/aesm/libsgx_qe3_logic.so.1
    ln -s libsgx_qe3_logic.so.1 $out/aesm/libsgx_qe3_logic.so
    # Place the default Intel quote provider in the fallback location, so the
    # configurable quote provider can take precedence if set.
    install -m755 "$(readlink -f $dcapBuild/libdcap_quoteprov.so)" \
      $out/aesm/libdcap_quoteprov.so

    # Copy the pre-built enclaves into place
    install -m755 psw/ae/data/prebuilt/libsgx_pce.signed.so \
      $out/aesm/libsgx_pce.signed.so.1
    install -m755 \
      external/dcap_source/QuoteGeneration/psw/ae/data/prebuilt/libsgx_qe3.signed.so \
      $out/aesm/libsgx_qe3.signed.so.1
    install -m755 \
      external/dcap_source/QuoteGeneration/psw/ae/data/prebuilt/libsgx_id_enclave.signed.so \
      $out/aesm/libsgx_id_enclave.signed.so.1

    # Install aesmd systemd service configs and udev rules. If you use
    # `services.aesmd` in NixOS, then this isn't actually used.
    install -m755 linux/installer/common/sgx-aesm-service/linksgx.sh $out/aesm/
    install -Dm644 psw/ae/aesm_service/config/network/aesmd.conf $out/etc/aesmd.conf
    install -Dm644 build/linux/aesmd.service $out/lib/systemd/system/aesmd.service
    install -Dm644 \
      sdk/build_infrastructure/linux/installer/common/libsgx-enclave-common/remount-dev-exec.service \
      $out/lib/systemd/system/remount-dev-exec.service
    install -Dm644 \
      sdk/build_infrastructure/linux/installer/common/libsgx-enclave-common/91-sgx-enclave.rules \
      $out/lib/udev/rules.d/91-sgx-enclave.rules
    install -Dm644 linux/installer/common/sgx-aesm-service/92-sgx-provision.rules \
      $out/lib/udev/rules.d/93-sgx-provision.rules
    install -Dm644 License.txt $out/share/licenses/License.txt

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
      --chdir "$out/aesm" \
      --suffix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          curl
          protobuf
        ]
      }:$out/aesm

    runHook postInstall
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

    # Fixup the aesmd systemd service for non-NixOS users.
    #
    # Most (if not all) of these fixups are not relevant for NixOS as we have
    # our own NixOS module which is based on those files without relying on
    # them. Still, it's helpful to have properly patched versions for non-NixOS
    # distros.
    substituteInPlace $out/lib/systemd/system/aesmd.service \
      --replace-fail '@aesm_folder@' \
                     "$out/aesm" \
      --replace-fail 'Type=forking' \
                     'Type=simple' \
      --replace-fail "ExecStart=$out/aesm/aesm_service" \
                     "ExecStart=$out/bin/aesm_service --no-daemon"\
      --replace-fail "/bin/mkdir" "${lib.getExe' coreutils "mkdir"}" \
      --replace-fail "/bin/chown" "${lib.getExe' coreutils "chown"}" \
      --replace-fail "/bin/chmod" "${lib.getExe' coreutils "chmod"}" \
      --replace-fail "/bin/kill"  "${lib.getExe' coreutils "kill"}"
  '';

  passthru = {
    inherit sgx-sdk-runtime;
    tests.service = nixosTests.aesmd;
  };

  meta = {
    description = "Intel SGX Architectural Enclave Service Manager";
    homepage = "https://github.com/intel/confidential-computing.sgx";
    maintainers = with lib.maintainers; [ phlip9 ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.bsd3;
  };
})
