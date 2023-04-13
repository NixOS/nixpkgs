{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "enumer";
  version = "1.5.8";

  src = fetchFromGitHub {
    owner = "dmarkham";
    repo = "enumer";
    rev = "refs/tags/v${version}";
    hash = "sha256-+YTsXYWVmJ32V/Eptip3WAiqIYv+6nqbdph0K2XzLdc=";
  };

  vendorHash = "sha256-+dCitvPz2JUbybXVJxUOo1N6+SUPCSjlacL8bTSlb7w=";

  meta = with lib; {
    description = "Go tool to auto generate methods for enums";
    homepage = "https://github.com/dmarkham/enumer";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
  };
}
