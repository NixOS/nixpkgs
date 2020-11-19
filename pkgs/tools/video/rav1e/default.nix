{ stdenv, rustPlatform, fetchurl, fetchFromGitHub, lib, nasm, cargo-c }:

rustPlatform.buildRustPackage rec {
  pname = "rav1e";
  version = "0.4.0-alpha";

  src = stdenv.mkDerivation rec {
    name = "${pname}-${version}-source";

    src = fetchFromGitHub {
      owner = "xiph";
      repo = "rav1e";
      rev = "v${version}";
      sha256 = "1fw1gxi8330kfhl9hfzpn0lcmyn5604lc74d6g6iadzz2hmv4mb9";
    };

    cargoLock = fetchurl {
      url = "https://github.com/xiph/rav1e/releases/download/v0.4.0-alpha/Cargo.lock";
      sha256 = "002s2wlzpifn5p2ahdrjdkjl48c1wr6fslg0if4gf9qpl8qj05fl";
    };

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/
      cp ${cargoLock} $out/Cargo.lock
    '';
  };

  cargoSha256 = "1i5ldqb77rrhfxxf9krp7f6yj3h6rsqak6hf23fd2znhgmi7psb1";
  nativeBuildInputs = [ nasm cargo-c ];

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
