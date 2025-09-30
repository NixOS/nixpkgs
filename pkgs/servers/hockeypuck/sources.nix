{ fetchFromGitHub }:

let
  pname = "hockeypuck";
  version = "2.1.0";
in
{
  inherit version pname;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0da3ffbqck0dr7d89gy2yillp7g9a4ziyjlvrm8vgkkg2fs8dlb1";
  };
}
