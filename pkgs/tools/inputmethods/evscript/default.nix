{ lib, rustPlatform, fetchFromGitea }:

rustPlatform.buildRustPackage rec {
  pname = "evscript";
  version = "unstable-2022-11-20";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "valpackett";
    repo = pname;
    rev = "ba997c9723a91717c683f08e9957d0ecea3da6cd";
    sha256 = "sha256-wuTPcBUuPK1D4VO8BXexx9AdiPM+X0TkJ3G7b7ofER8=";
  };

  cargoSha256 = "sha256-5jcb/MajXV9bp0T9Og8d5TEzTwQyiyPTPHeWh8Ewr8Q=";

  meta = with lib; {
    homepage = "https://codeberg.org/valpackett/evscript";
    description = "A tiny sandboxed Dyon scripting environment for evdev input devices";
    license = licenses.unlicense;
    maintainers = with maintainers; [ milesbreslin ];
    platforms = platforms.linux;
  };
}
