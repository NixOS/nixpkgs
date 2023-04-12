{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "sha256-vUvDdeowbrmDQvUCUYRjOGQQrlyGGKrnXsYFsMWMfFw=";
  };

  cargoHash = "sha256-zb1F3bv1MrXkoBzTaVXbHcKFlg5R9Ulq6eN8mh8WKSg=";

  meta = with lib; {
    description = "SystemVerilog language server";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
