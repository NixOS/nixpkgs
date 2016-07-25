{ lib, pythonPackages, fetchurl, git }:

pythonPackages.buildPythonApplication rec {
  name = "nox-${version}";
  version = "0.0.4";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/n/nix-nox/nix-nox-${version}.tar.gz";
    sha256 = "11f6css8rnh7qz55z7i81cnb5h9ys98fqxq3fps3hsh64zlydj52";
  };

  buildInputs = [ pythonPackages.pbr git ];

  propagatedBuildInputs = with pythonPackages; [
      dogpile_cache
      click
      requests2
      characteristic
    ];

  meta = {
    homepage = https://github.com/madjar/nox;
    description = "Tools to make nix nicer to use";
    maintainers = [ lib.maintainers.madjar ];
    platforms = lib.platforms.all;
  };
}
