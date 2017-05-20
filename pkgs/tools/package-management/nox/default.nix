{ lib, pythonPackages, fetchurl, git }:

pythonPackages.buildPythonApplication rec {
  name = "nox-${version}";
  version = "0.0.5";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/n/nix-nox/nix-nox-${version}.tar.gz";
    sha256 = "1kwrkp7njxn2sqmmzy5d33d07gawbw2ab2bmfjz0y1r23z9iadf2";
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
