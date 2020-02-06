{ rustPlatform, fetchFromGitHub, fetchurl, stdenv, lib, nasm }:

rustPlatform.buildRustPackage rec {
  pname = "rav1e";
  version = "0.2.1";

  src = stdenv.mkDerivation rec {
    name = "${pname}-${version}-source";

    src = fetchFromGitHub {
      owner = "xiph";
      repo = "rav1e";
      rev = "v${version}";
      sha256 = "1lv8g1vw11lanyx6lqr34hb6m4x1fvwb60kgg5nk8s8hgdr18i0y";
    };
    cargoLock = fetchurl {
      url = "https://github.com/xiph/rav1e/releases/download/v${version}/Cargo.lock";
      sha256 = "1d51wcm537pzfmq48vsv87dwf035yl03qkfc0372gchpv079561w";
    };

    installPhase = ''
      mkdir -p $out
      cp -R ./* $out/
      cp ${cargoLock} $out/Cargo.lock
    '';
  };

  cargoSha256 = "0frr4sx05pwvj9gmlvmis6lrnbwk3x579fv3kw38374jy33nrr6z";

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
