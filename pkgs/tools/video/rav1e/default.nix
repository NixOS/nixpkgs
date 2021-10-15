{ lib, rust, stdenv, rustPlatform, fetchCrate, nasm, cargo-c, libiconv }:

let
  rustTargetPlatformSpec = rust.toRustTargetSpec stdenv.hostPlatform;
in rustPlatform.buildRustPackage rec {
  pname = "rav1e";
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-9fBAH1vuLJ3yu8X5+CQGLQFDlzTYoFBUTy3Muo6hLkw=";
  };

  cargoSha256 = "sha256-QhWVqHcNjJF94uTvHGVnV8MTp2bYOuCEjaMBfViOLRo=";

  nativeBuildInputs = [ nasm cargo-c ];
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

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
