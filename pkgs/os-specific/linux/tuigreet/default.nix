{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tuigreet";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "apognu";
    repo = pname;
    rev = version;
    sha256 = "1fk8ppxr3a8vdp7g18pp3sgr8b8s11j30mcqpdap4ai14v19idh8";
  };

  cargoSha256 = "1ds5rcxg7qn799zp0jdn9ifkdzh9h5ibsqh688dvrqyzrsfz6x7m";

  meta = with lib; {
    description = "Graphical console greter for greetd";
    homepage = "https://github.com/apognu/tuigreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}
