{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, xz
, autoPatchelfHook }:

let
  assets = import ./assets.nix {
    inherit lib stdenv fetchFromGitHub xz autoPatchelfHook;
  };
in
rustPlatform.buildRustPackage rec {
  pname = "fishnet";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "niklasf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SAEhb0R2wbo8xk/xknGv29F0/8ZaxTXkwX+l+hRPLj4=";
  };

  cargoSha256 = "sha256-sgSMYWXu8vvNk4jra/aZoCF+2KK5RzzJqKdm9y2AHkM=";

  preBuild = ''
    rmdir ./assets
    ln -snf ${assets}/${assets.relAssetsPath} ./assets
  '';

  meta = with lib; {
    description = "Distributed Stockfish analysis for lichess.org";
    homepage = "https://github.com/niklasf/fishnet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tu-maurice ];
  };
}
