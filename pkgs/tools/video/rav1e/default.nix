{ rustPlatform, fetchFromGitHub, fetchurl, stdenv, lib, nasm }:

rustPlatform.buildRustPackage rec {
  pname = "rav1e";
  version = "0.3.1";

  src = stdenv.mkDerivation rec {
    name = "${pname}-${version}-source";

    src = fetchFromGitHub {
      owner = "xiph";
      repo = "rav1e";
      rev = "v${version}";
      sha256 = "001v29baa77pkab13d7imi71llixyvffqax8kgjwhm1dhsqlm7bl";
    };
    cargoLock = fetchurl {
      url = "https://github.com/xiph/rav1e/releases/download/v${version}/Cargo.lock";
      sha256 = "06l8jj75ma5kvz1m14x58an2zvx12i6wcq70gzq5k47nvj5l0zax";
    };

    installPhase = ''
      mkdir -p $out
      cp -R ./* $out/
      cp ${cargoLock} $out/Cargo.lock
    '';
  };

  cargoSha256 = "0n6gkn4iyqk4bijrvcpq884hiihl4mpw1p417w1m0dw7j4y4karn";

  nativeBuildInputs = [ nasm ];

  meta = with lib; {
    description = "The fastest and safest AV1 encoder";
    longDescription = ''
      rav1e is an AV1 video encoder. It is designed to eventually cover all use
      cases, though in its current form it is most suitable for cases where
      libaom (the reference encoder) is too slow.
      Features: https://github.com/xiph/rav1e#features
    '';
    inherit (src.src.meta) homepage;
    license = licenses.bsd2;
    maintainers = [ maintainers.primeos ];
    platforms = platforms.all;
  };
}
