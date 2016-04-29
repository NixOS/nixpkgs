{ lib, pythonPackages, fetchurl }:

pythonPackages.buildPythonApplication rec {
  name = "nox-${version}";
  version = "0.0.2";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/n/nix-nox/nix-nox-${version}.tar.gz";
    sha256 = "1wpxh5fhj8nx4yx4cvmc087cnf4iqwxf7zd7rdh2ln3pgxrjfral";
  };

  buildInputs = [ pythonPackages.pbr ];

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
