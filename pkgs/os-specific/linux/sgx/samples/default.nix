{
  stdenv,
  lib,
  makeWrapper,
  openssl,
  sgx-sdk,
  sgx-psw,
  which,
  # "SIM" or "HW"
  sgxMode,
}:
let
  isSimulation = sgxMode == "SIM";
  buildSample =
    name:
    stdenv.mkDerivation {
      pname = name;
      version = sgxMode;

      src = sgx-sdk.out;
      sourceRoot = "${sgx-sdk.name}/share/SampleCode/${name}";

      nativeBuildInputs = [
        makeWrapper
        openssl
        which
      ];

      buildInputs = [
        sgx-sdk
      ];

      # The samples don't have proper support for parallel building
      # causing them to fail randomly.
      enableParallelBuilding = false;

      buildFlags = [
        "SGX_MODE=${sgxMode}"
      ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/{bin,lib}
        install -m 755 app $out/bin
        install *.so $out/lib

        wrapProgram "$out/bin/app" \
          --chdir "$out/lib" \
          ${lib.optionalString (!isSimulation)
            ''--prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ sgx-psw ]}"''
          }

        runHook postInstall
      '';

      # Breaks the signature of the enclaves
      dontFixup = true;

      # We don't have access to real SGX hardware during the build
      doInstallCheck = isSimulation;
      installCheckPhase = ''
        runHook preInstallCheck

        pushd /
        echo a | $out/bin/app
        popd

        runHook preInstallCheck
      '';
    };
in
{
  cxx11SGXDemo = buildSample "Cxx11SGXDemo";
  cxx14SGXDemo = buildSample "Cxx14SGXDemo";
  cxx17SGXDemo = buildSample "Cxx17SGXDemo";
  localAttestation = (buildSample "LocalAttestation").overrideAttrs (old: {
    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,lib}
      install -m 755 bin/app* $out/bin
      install bin/*.so $out/lib

      for bin in $out/bin/*; do
        wrapProgram $bin \
          --chdir "$out/lib" \
          ${lib.optionalString (!isSimulation)
            ''--prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ sgx-psw ]}"''
          }
      done

      runHook postInstall
    '';
  });
  powerTransition = buildSample "PowerTransition";
  protobufSGXDemo = buildSample "ProtobufSGXDemo";
  remoteAttestation = (buildSample "RemoteAttestation").overrideAttrs (old: {
    # Makefile sets rpath to point to $TMPDIR
    preFixup = ''
      patchelf --remove-rpath $out/bin/app
    '';

    postInstall = ''
      install sample_libcrypto/*.so $out/lib
    '';
  });
  sampleEnclave = buildSample "SampleEnclave";
  sampleEnclaveGMIPP = buildSample "SampleEnclaveGMIPP";
  sampleMbedCrypto = buildSample "SampleMbedCrypto";
  sealUnseal = (buildSample "SealUnseal").overrideAttrs (old: {
    prePatch = ''
      substituteInPlace App/App.cpp \
        --replace '"sealed_data_blob.txt"' '"/tmp/sealed_data_blob.txt"'
    '';
  });
  switchless = buildSample "Switchless";
  # # Requires SGX-patched openssl (sgxssl) build
  # sampleAttestedTLS = buildSample "SampleAttestedTLS";
}
// lib.optionalAttrs (!isSimulation) {
  # # Requires kernel >= v6.2 && HW SGX
  # sampleAEXNotify = buildSample "SampleAEXNotify";

  # Requires HW SGX
  sampleCommonLoader = (buildSample "SampleCommonLoader").overrideAttrs (old: {
    nativeBuildInputs = [ sgx-psw ] ++ old.nativeBuildInputs;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,lib}
      mv sample app
      install -m 755 app $out/bin

      wrapProgram "$out/bin/app" \
        --chdir "$out/lib" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ sgx-psw ]}"

      runHook postInstall
    '';
  });

  # # SEGFAULTs in simulation mode?
  # sampleEnclavePCL = buildSample "SampleEnclavePCL";
}
