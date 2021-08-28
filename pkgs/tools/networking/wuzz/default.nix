{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "wuzz";
  version = "0.2.0";
  rev = "v${version}";

  goPackagePath = "https://github.com/asciimoo/wuzz";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "wuzz";
    inherit rev;
    sha256 = "1fcr5jr0vn5w60bn08lkh2mi0hdarwp361h94in03139j7hhqrfs";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    homepage = "https://github.com/asciimoo/wuzz";
    description = "Interactive cli tool for HTTP inspection";
    license = licenses.agpl3;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
