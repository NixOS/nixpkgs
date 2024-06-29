{ lib
, sgx-azure-dcap-client
, gtest
, makeWrapper
}:
sgx-azure-dcap-client.overrideAttrs (old: {
  nativeBuildInputs = old.nativeBuildInputs ++ [
    makeWrapper
    gtest
  ];

  patches = (old.patches or []) ++ [
    ./tests-missing-includes.patch
  ];

  buildFlags = [
    "tests"
  ];

  installPhase = ''
    runHook preInstall

    install -D ./src/Linux/tests "$out/bin/tests"

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/tests" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ sgx-azure-dcap-client ]}"
  '';
})
