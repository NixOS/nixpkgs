{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "renderizer";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "gomatic";
    repo = pname;
    rev = version;
    sha256 = "186wcfzw60z6i59yl37rkppw8w88z5kikvsi65k4r9kwpll2z6z4";
  };

  modSha256 = "1sxg9skd5hjpg2f4wyxh5hwjrplw3b3v32gn61a9yixfk3wvi05x";

  meta = with stdenv.lib; {
    description = "CLI to render Go template text files";
    inherit (src.meta) homepage;
    license = licenses.gpl3;
    maintainers = with maintainers; [ yurrriq ];
  };
}
