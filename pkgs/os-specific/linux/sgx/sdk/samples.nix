{ stdenv
, sgx-sdk
, which
}:
let
  buildSample = name: stdenv.mkDerivation rec {
    inherit name;

    src = sgx-sdk.out;
    sourceRoot = "${sgx-sdk.name}/share/SampleCode/${name}";

    buildInputs = [
      sgx-sdk
    ];

    # The samples don't have proper support for parallel building
    # causing them to fail randomly.
    enableParallelBuilding = false;

    buildFlags = [
      "SGX_MODE=SIM"
    ];

    installPhase = ''
      mkdir $out
      install -m 755 app $out/app
      install *.so $out/
    '';

    doInstallCheck = true;
    installCheckInputs = [ which ];
    installCheckPhase = ''
      pushd $out
      ./app
      popd
    '';
  };
in
{
  cxx11SGXDemo = buildSample "Cxx11SGXDemo";
  localAttestation = (buildSample "LocalAttestation").overrideAttrs (oldAttrs: {
    installPhase = ''
      mkdir $out
      cp -r bin/. $out/
    '';
  });
  powerTransition = (buildSample "PowerTransition").overrideAttrs (oldAttrs: {
    # Requires interaction
    doInstallCheck = false;
  });
  protobufSGXDemo = buildSample "ProtobufSGXDemo";
  remoteAttestation = (buildSample "RemoteAttestation").overrideAttrs (oldAttrs: {
    dontFixup = true;
    installCheckPhase = ''
      echo "a" | LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/sample_libcrypto ./app
    '';
  });
  sampleEnclave = buildSample "SampleEnclave";
  sampleEnclavePCL = buildSample "SampleEnclavePCL";
  sampleEnclaveGMIPP = buildSample "SampleEnclaveGMIPP";
  sealUnseal = buildSample "SealUnseal";
  switchless = buildSample "Switchless";
}
