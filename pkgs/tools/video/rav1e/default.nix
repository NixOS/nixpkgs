{ stdenv, rustPlatform, rust, fetchurl, fetchFromGitHub, lib, nasm, cargo-c, libiconv }:

let
  rustTargetPlatformSpec = rust.toRustTargetSpec stdenv.hostPlatform;
in rustPlatform.buildRustPackage rec {
  pname = "rav1e";
  version = "0.4.1";

  src = stdenv.mkDerivation rec {
    name = "${pname}-${version}-source";

    src = fetchFromGitHub {
      owner = "xiph";
      repo = "rav1e";
      rev = "v${version}";
      sha256 = "0jnq5a3fv6fzzbmprzfxidlcwwgblkwwm0135cfw741wjv7f7h6r";
    };

    cargoLock = fetchurl {
      url = "https://github.com/xiph/rav1e/releases/download/v${version}/Cargo.lock";
      sha256 = "14fi9wam9rs5206rvcd2f3sjpzq41pnfml14w74wn2ws3gpi46zn";
    };

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/
      cp ${cargoLock} $out/Cargo.lock
    '';
  };

  cargoSha256 = "0miq6iiywwbxm6k0alnqg6bnd14pwc8vl9d8fgg6c0vjlfy5zhlb";
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
