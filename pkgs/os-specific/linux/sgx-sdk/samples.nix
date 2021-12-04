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
    enableParallelBuilding = true;   
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
  remoteAttestation = (buildSample "RemoteAttestation").overrideAttrs (oldAttrs: {
    dontFixup = true;
    installCheckPhase = ''
      echo "a" | LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/sample_libcrypto ./app
    '';
  });
  sampleEnclave = buildSample "SampleEnclave";
  sampleEnclavePCL = buildSample "SampleEnclavePCL";
  sealUnseal = buildSample "SealUnseal";
  switchless = buildSample "Switchless";
}
