{ fetchFromGitHub }:

rec {
  version = "unstable-20180706";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "de791931d94e972c36bb3c102a9cadab5230c285";
    sha256 = "09mr7lc9k17znpslsfmndx4vgl240llcgblxm92fizmwz23y1d6c";
  };
}
