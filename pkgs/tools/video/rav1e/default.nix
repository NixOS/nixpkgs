{ lib, rust, stdenv, rustPlatform, fetchCrate, nasm, cargo-c, libiconv }:

let
  rustTargetPlatformSpec = rust.toRustTargetSpec stdenv.hostPlatform;
in rustPlatform.buildRustPackage rec {
  pname = "rav1e";
  version = "0.5.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-v2i/dMWos+nB3cRDOkROSOPb1ONRosbmp9RDZI2DLeI=";
  };

  cargoSha256 = "sha256-V9QbztkFj3t5yBV+yySysDy3Q6IUY4gNzBL8h23aEg4=";

  nativeBuildInputs = [ nasm cargo-c ];
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  checkType = "debug";

  postBuild = ''
    cargo cbuild --release --frozen --prefix=${placeholder "out"} --target ${rustTargetPlatformSpec}
  '';

  postInstall = ''
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
