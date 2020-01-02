{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "clash";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zhbaw9jzl9wqc7yx8yxqlb6fwkss4pqkv26069qg6nsk584ndnf";
  };

  modSha256 = "0vyd61bin7hmpdqrmrikc776mgif9v25627n8hzi65kiycv40kgx";

  meta = with stdenv.lib; {
    description = "A rule-based tunnel in Go";
    homepage = "https://github.com/Dreamacro/clash";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun filalex77 ];
    platforms = platforms.all;
  };
}
