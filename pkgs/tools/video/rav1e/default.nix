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
  version = "0.6.6";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-urYMT1sJUMBj1L/2Hi+hcYbWbi0ScSls0pm9gLj9H3o=";
  };

  cargoHash = "sha256-qQfEpynhlIEKU1Ptq/jM1Wdtn+BVCZT1lmou2S1GL4I=";

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [ cargo-c libgit2 nasm ];

  buildInputs = [
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    Security
  ];

  # Darwin uses `llvm-strip`, which results in link errors when using `-x` to strip the asm library
  # and linking it with cctools ld64.
  postPatch = lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
    substituteInPlace build.rs --replace 'cmd.arg("-x")' 'cmd.arg("-S")'
  '';

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
