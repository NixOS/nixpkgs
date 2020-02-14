{ rustPlatform, fetchFromGitHub, fetchurl, stdenv, lib, nasm }:

rustPlatform.buildRustPackage rec {
  pname = "rav1e";
  version = "0.3.0";

  src = stdenv.mkDerivation rec {
    name = "${pname}-${version}-source";

    src = fetchFromGitHub {
      owner = "xiph";
      repo = "rav1e";
      rev = "v${version}";
      sha256 = "1z8wdwhmczd7qq61gpngnyhl9614csccm0vnavvzjmaqsljlm0qi";
    };
    cargoLock = fetchurl {
      url = "https://github.com/xiph/rav1e/releases/download/v${version}/Cargo.lock";
      sha256 = "0qhgiryb71qgil5nawy7n3mj5g9aiikl3hq3nlikg94rm9dl0dhv";
    };

    installPhase = ''
      mkdir -p $out
      cp -R ./* $out/
      cp ${cargoLock} $out/Cargo.lock
    '';
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "185jnmyirfhrv8bxvmwizf3lvq49sjj1696g3gflph31d8bfpb0c";

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
