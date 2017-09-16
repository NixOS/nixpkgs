{ lib, pythonPackages, fetchurl, git }:

pythonPackages.buildPythonApplication rec {
  name = "nox-${version}";
  version = "0.0.6";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/n/nix-nox/nix-nox-${version}.tar.gz";
    sha256 = "1qcbhdnhdhhv7q6cqdgv0q55ic8fk18526zn2yb12x9r1s0lfp9z";
  };

  buildInputs = [ pythonPackages.pbr git ];

  propagatedBuildInputs = with pythonPackages; [
      dogpile_cache
      click
      requests
      characteristic
    ];

  meta = {
    homepage = https://github.com/madjar/nox;
    description = "Tools to make nix nicer to use";
    maintainers = [ lib.maintainers.madjar ];
    platforms = lib.platforms.all;
  };
}
