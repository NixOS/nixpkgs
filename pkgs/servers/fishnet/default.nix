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
    sha256 = "0gif9wagm9bzq7j3biasqvzp9lfvmxqr5wagqqybmhbn8ipj20a8";
  };

  cargoSha256 = "0hqyh0nzfrm7m34kqixrlbc7w8d0k7v6psw8jg6zpwpfcmhqq15j";

  preBuild = ''
    rmdir ./assets
    ln -snf ${assets}/${assets.relAssetsPath} ./assets
  '';

  meta = with lib; {
    description = "Distributed Stockfish analysis for lichess.org";
    homepage = "https://github.com/niklasf/fishnet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tu-maurice ];
    platforms = [ "x86_64-linux" ];
  };
}
