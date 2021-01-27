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
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "niklasf";
    repo = pname;
    rev = "v${version}";
    sha256 = "159fwjy70n6lvnhdwv65azgi03r5qcc2m2zpzgz0k3r6cy06faxj";
  };

  cargoSha256 = "1bfs8dy08799r6d63sb33zwcxas3gzp7jvcxv3w8n64gffan8f2n";

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
