{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mbtileserver";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "consbio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hKDgKiy3tmZ7gxmxZlflJHcxatrSqE1d1uhSLJh8XLo=";
  };

  vendorHash = "sha256-QcyFnzRdGdrVqgKEMbhaD7C7dkGKKhTesMMZKrrLx70=";

  meta = with lib; {
    description = "A simple Go-based server for map tiles stored in mbtiles format";
    homepage = "https://github.com/consbio/mbtileserver";
    changelog = "https://github.com/consbio/mbtileserver/blob/v${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ sikmir ];
  };
}
