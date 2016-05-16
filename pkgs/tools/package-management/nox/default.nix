{ lib, pythonPackages, fetchurl }:

pythonPackages.buildPythonApplication rec {
  name = "nox-${version}";
  version = "0.0.3";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/n/nix-nox/nix-nox-${version}.tar.gz";
    sha256 = "0bbd8nyvxwwz56qp82h3bln960bmpy2lczxr00h2jva1gpz5a964";
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
