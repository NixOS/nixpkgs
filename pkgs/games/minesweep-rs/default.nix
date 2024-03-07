{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "minesweep-rs";
  version = "6.0.47";

  src = fetchFromGitHub {
    owner = "cpcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6BrFWJ7YGALdKaPAX8Z1W2Eyyj0kbegybmwdnNUmOYo=";
  };

  cargoHash = "sha256-ju4tIie0Jrm9hh5Xoy4dqfPS8mqdN9Y0J1Nw4T9aN3Y=";

  meta = with lib; {
    description = "Sweep some mines for fun, and probably not for profit";
    homepage = "https://github.com/cpcloud/minesweep-rs";
    license = licenses.asl20;
    mainProgram = "minesweep";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.all;
  };
}
