{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mbtileserver";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "consbio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aa0YsP+SYYDtaSstTfluEe0/+yDl82KHUSss8LZ2gOc=";
  };

  vendorSha256 = "sha256-eVnL+28eOgbR0bjWv7XotcHDl5309EO0wV8AGMslvZw=";

  meta = with lib; {
    description = "A simple Go-based server for map tiles stored in mbtiles format";
    homepage = "https://github.com/consbio/mbtileserver";
    changelog = "https://github.com/consbio/mbtileserver/blob/v${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
