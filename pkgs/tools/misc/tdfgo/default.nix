{ lib, buildGo118Module, fetchFromGitHub }:

buildGo118Module rec {
  pname = "tdfgo";
  version = "unstable-2022-08-25";

  src = fetchFromGitHub {
    owner = "digitallyserviced";
    repo = "tdfgo";
    rev = "9f0b3315eed32409639a05aca55d7a0252681193";
    sha256 = "sha256-Lr4+bXdVxYbCXKVzE+fjeLD559HuABK6lOLJ0sBBGNY=";
  };

  vendorSha256 = "sha256-T6PSs5NfXSXvzlq67rIDbzURyA+25df3nMMfufo0fow=";

  meta = with lib; {
    description = "TheDraw font parser and console text renderer.";
    longDescription = "Supports more fonts than `tdfiglet`, and packs more features.";
    homepage = "https://github.com/digitallyserviced/tdfgo";
    license = licenses.cc0;
    platforms = platforms.linux;
    maintainers = with maintainers; [ crinklywrappr ];
  };
}
