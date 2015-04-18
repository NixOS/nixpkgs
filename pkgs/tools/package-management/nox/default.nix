{ lib, pythonPackages, fetchurl }:

pythonPackages.buildPythonPackage rec {
  name = "nox-${version}";
  version = "0.0.1";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/n/nix-nox/nix-nox-${version}.tar.gz";
    sha256 = "1s1jhickdhym70qrb5h4qxq1mvkpwgdppqpfb2jnpfaf1az6c207";
  };

  buildInputs = [ pythonPackages.pbr ];

  pythonPath = with pythonPackages; [
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
