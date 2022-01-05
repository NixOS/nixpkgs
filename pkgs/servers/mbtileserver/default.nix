{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mbtileserver";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "consbio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C6Gz+RBUrjnfJWo4Ou+s/JYJ8iVP9FMYJ/cxJjcVsXk=";
  };

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
