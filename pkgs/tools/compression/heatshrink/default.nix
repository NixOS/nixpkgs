{ lib
, stdenv
, fetchFromGitHub
, cmake
, fetchpatch
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "heatshrink";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "atomicobject";
    repo = "heatshrink";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Nm9/+JFMDXY1N90hmNFGh755V2sXSRQ4VBN9f8TcsGk=";
  };

  patches = [
    # Add CMake build script, wanted by prusa-slicer and libbgcode, which are the only users of this library.
    (fetchpatch {
      url = "https://github.com/atomicobject/heatshrink/commit/0886e9ca76552b8e325841e2b820b4563e5d5aba.patch";
      hash = "sha256-13hy4+/RDaaKgQcdaSbACvMfElUIskvJ+owXqm40feY=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    echo "Hello world" | \
      $out/bin/heatshrink -e - | \
      $out/bin/heatshrink -d - | \
      grep "Hello world"
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A data compression/decompression library for embedded/real-time systems";
    homepage = "https://github.com/atomicobject/heatshrink";
    license = licenses.isc;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    mainProgram = "heatshrink";
  };
})
