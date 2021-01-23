{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gore";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "motemen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oiaZvoCxA69slNb3LArLJfaqzfQ1YImxLuQHzW5tibo=";
  };

  vendorSha256 = "sha256-vJG7sc+ngagtrYvTwO3OrCSFUgAA7zhaXHkU97nIhcY=";

  doCheck = false;

  meta = with lib; {
    description = "Yet another Go REPL that works nicely";
    homepage = "https://github.com/motemen/gore";
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
  };
}
