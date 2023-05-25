{ lib
, rust
, stdenv
, rustPlatform
, fetchCrate
, pkg-config
, cargo-c
, libgit2
, nasm
, zlib
, libiconv
, Security
, buildPackages
}:

let
  rustTargetPlatformSpec = rust.toRustTargetSpec stdenv.hostPlatform;

  # TODO: if another package starts using cargo-c (seems likely),
  # factor this out into a makeCargoChook expression in
  # pkgs/build-support/rust/hooks/default.nix
  ccForBuild = "${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc";
  cxxForBuild = "${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}c++";
  ccForHost = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
  cxxForHost = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++";
  rustBuildPlatform = rust.toRustTarget stdenv.buildPlatform;
  rustTargetPlatform = rust.toRustTarget stdenv.hostPlatform;
  setEnvVars = ''
    env \
      "CC_${rustBuildPlatform}"="${ccForBuild}" \
      "CXX_${rustBuildPlatform}"="${cxxForBuild}" \
      "CC_${rustTargetPlatform}"="${ccForHost}" \
      "CXX_${rustTargetPlatform}"="${cxxForHost}" \
  '';

in rustPlatform.buildRustPackage rec {
  pname = "rav1e";
  version = "0.6.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-G7o82MAZmMOfs1wp3AVUgXxDW6Txuc0qTm5boRpXF6g=";
  };

  cargoHash = "sha256-12bePpI8z35gzCHGKDpaGUVvosQqijP60NCgElHDsyw=";

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [ cargo-c libgit2 nasm ];

  buildInputs = [
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    Security
  ];

  checkType = "debug";

  postBuild =  ''
    ${setEnvVars} \
    cargo cbuild --release --frozen --prefix=${placeholder "out"} --target ${rustTargetPlatformSpec}
  '';

  postInstall = ''
    ${setEnvVars} \
    cargo cinstall --release --frozen --prefix=${placeholder "out"} --target ${rustTargetPlatformSpec}
  '';

  meta = with lib; {
    description = "The fastest and safest AV1 encoder";
    longDescription = ''
      rav1e is an AV1 video encoder. It is designed to eventually cover all use
      cases, though in its current form it is most suitable for cases where
      libaom (the reference encoder) is too slow.
      Features: https://github.com/xiph/rav1e#features
    '';
    homepage = "https://github.com/xiph/rav1e";
    changelog = "https://github.com/xiph/rav1e/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
