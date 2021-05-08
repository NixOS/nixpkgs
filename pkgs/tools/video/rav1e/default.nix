{ stdenv, rustPlatform, fetchurl, fetchFromGitHub, lib, nasm, cargo-c, libiconv }:

rustPlatform.buildRustPackage rec {
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

  cargoSha256 = "1j92prjyr86wyx58h10xq9c9z28ky86h291x65w7qrxpj658aiz1";
  nativeBuildInputs = [ nasm cargo-c ];
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  postBuild = ''
    cargo cbuild --release --frozen --prefix=${placeholder "out"}
  '';

  postInstall = ''
    cargo cinstall --release --frozen --prefix=${placeholder "out"}
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
    maintainers = [ maintainers.primeos ];
  };
}
