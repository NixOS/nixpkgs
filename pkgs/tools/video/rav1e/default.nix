{ rustPlatform, fetchFromGitHub, fetchurl, stdenv, lib, nasm }:

rustPlatform.buildRustPackage rec {
  pname = "rav1e";
  version = "0.3.2";

  src = stdenv.mkDerivation rec {
    name = "${pname}-${version}-source";

    src = fetchFromGitHub {
      owner = "xiph";
      repo = "rav1e";
      rev = "v${version}";
      sha256 = "0qqw397yfglwj9kg45imhx1p5bb0nsx2gkaxj4lcc9i1hav6ia43";
    };
    cargoLock = fetchurl {
      url = "https://github.com/xiph/rav1e/releases/download/v${version}/Cargo.lock";
      sha256 = "1kdr3q97vq3mip1h7iv2iy9qzlgb69y6nwjzbw9nfi7dl7ip6q3l";
    };

    installPhase = ''
      mkdir -p $out
      cp -R ./* $out/
      cp ${cargoLock} $out/Cargo.lock
    '';
  };

  cargoSha256 = "03zsvavk7wskz843qxwwcymhclarcp6nfxwa1mwna3nmzvlm1hwb";

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
    changelog = "https://github.com/xiph/rav1e/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = [ maintainers.primeos ];
    platforms = platforms.all;
  };
}
