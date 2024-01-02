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

rustPlatform.buildRustPackage rec {
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
    ${rust.envVars.setEnv} cargo cbuild --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
  '';

  postInstall = ''
    ${rust.envVars.setEnv} cargo cinstall --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
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
    mainProgram = "rav1e";
  };
}
