{ lib
, rustPlatform
, makeRustPlatform
, fetchFromGitHub
, pkg-config
, protobuf
, openssl
, libiconv
, darwin
, stdenv
, callPackage
, patchelf
}:

let
  # TODO(nick): switch to the source repo once the issue (mozilla/nixpkgs-mozilla#304) has been
  # resolved. For now, use the commit from the potential resolution PR (mozilla/nixpkgs-mozilla#309).
  mozillaOverlay = fetchFromGitHub {
    repo = "nixpkgs-mozilla";
    # owner = "mozilla";
    # rev = "c7104980ce2fa4c962097c767bd84dafc782b708";
    # sha256 = "sha256-cS1aAmCV2DlLzPwXjiZfE7yd097zxthAUzxyNY5RtKE=";
    owner = "ggreif";
    rev = "c72bae8641d4486b3bd7b556d577df519f640f9a";
    sha256 = "sha256-CvRZhHWqaitvO5n4H5mUNIVFxESlTDV7E6BdYxDQVHo=";
  };
  mozilla = callPackage "${mozillaOverlay.out}/package-set.nix" { };

  date = "2023-03-07";
  rustNightly = (mozilla.rustChannelOf { inherit date; channel = "nightly"; }).rust;
  rustPlatform = makeRustPlatform {
    cargo = rustNightly;
    rustc = rustNightly;
  };

in
rustPlatform.buildRustPackage rec {
  pname = "buck2";
  version = "unstable-2023-05-17";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    rev = "816d51496cce751ecc54db2dcb297756ec7bdbf6";
    sha256 = "sha256-QxOAsrRgZ03jRUt1GynpLLxATpNvtuFMtz2HRoWmeD8=";
  };

  # TODO(nick): find a way to update the outputHashes in "update.sh".
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hyper-proxy-0.10.0" = "sha256-MeEWEP9xcQlVO8EA0U1/0uRJrdJMqlthIZx4qdus8Mg=";
      "perf-event-0.4.8" =
        "sha256-4OSGmbrL5y1g+wdA+W9DrhWlHQGeVCsMLz87pJNckvw=";
      "tonic-0.8.3" = "sha256-xuQVixIxTDS4IZIN46aMAer3v4/81IQEG975vuNNerU=";
    };
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  doCheck = false;

  nativeBuildInputs = [ pkg-config protobuf patchelf ];
  buildInputs =
    [ openssl patchelf ] ++ lib.optionals stdenv.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.CoreServices
    ];

  BUCK2_BUILD_PROTOC = "${protobuf}/bin/protoc";
  BUCK2_BUILD_PROTOC_INCLUDE = "${protobuf}/include";

  meta = with lib; {
    description = "Build system, successor to Buck";
    homepage = "https://github.com/facebook/buck2";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ nickgerace ];
  };

  passthru.updateScript = ./update.sh;
}

