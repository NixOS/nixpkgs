{ stdenv, rustPlatform, fetchurl, fetchFromGitHub, lib, nasm, cargo-c }:

rustPlatform.buildRustPackage rec {
  pname = "rav1e";
  version = "0.4.0";

  src = stdenv.mkDerivation rec {
    name = "${pname}-${version}-source";

    src = fetchFromGitHub {
      owner = "xiph";
      repo = "rav1e";
      rev = "v${version}";
      sha256 = "09w4476x6bdmh9pv4lchrzvfvbjvxxraa9f4dlbwgli89lcg9fcf";
    };

    cargoLock = fetchurl {
      url = "https://github.com/xiph/rav1e/releases/download/v${version}/Cargo.lock";
      sha256 = "0rkyi010z6qmwdpvzlzyrrhs8na929g11lszhbqx5y0gh3y5nyik";
    };

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/
      cp ${cargoLock} $out/Cargo.lock
    '';
  };

  cargoSha256 = "1iza2cws28hd4a3q90mc90l8ql4bsgapdznfr6bl65cjam43i5sg";
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
