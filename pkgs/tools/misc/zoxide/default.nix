{ lib
, fetchFromGitHub
, rustPlatform
, withFzf ? true
, fzf
}:
let
  version = "0.4.3";
in
rustPlatform.buildRustPackage {
  pname = "zoxide";
  inherit version;

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    rev = "v${version}";
    sha256 = "1ghdal6pqkp56rqawhj26ch1x4cvnjj032xz3626aiddqgn134zj";
  };

  postPatch = lib.optionalString withFzf ''
    substituteInPlace src/fzf.rs \
      --replace '"fzf"' '"${fzf}/bin/fzf"'
  '';

  cargoSha256 = "0klnjmda77bq9i9f0rz48jzaw4rcf7hafcjjpb0i570d7hlxnwsr";

  meta = with lib; {
    description = "A fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr cole-h ];
    platforms = platforms.all;
  };
}
