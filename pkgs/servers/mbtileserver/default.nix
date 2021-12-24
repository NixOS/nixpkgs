{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mbtileserver";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "consbio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0wSc2DIfK6o3kSiH2sSQcYRR5dHnQbnJC6SX6DwVk1c=";
  };

  # https://github.com/consbio/mbtileserver/issues/130
  postPatch = lib.optionalString stdenv.isAarch64 ''
    substituteInPlace handlers/tile_test.go \
      --replace "Test_CalcScaleResolution" "Skip_CalcScaleResolution"
  '';

  vendorSha256 = "sha256-36tUTZud0hxH9oZlnKxeK/xzoEzfw3xFMnd/r0srw6U=";

  meta = with lib; {
    description = "A simple Go-based server for map tiles stored in mbtiles format";
    homepage = "https://github.com/consbio/mbtileserver";
    changelog = "https://github.com/consbio/mbtileserver/blob/v${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
