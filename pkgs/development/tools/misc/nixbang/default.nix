{
  lib,
  pythonPackages,
  fetchFromGitHub,
}:

pythonPackages.buildPythonApplication rec {
  pname = "nixbang";
  version = "0.1.2";
  format = "setuptools";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "madjar";
    repo = "nixbang";
    rev = version;
    sha256 = "1kzk53ry60i814wa6n9y2ni0bcxhbi9p8gdv10b974gf23mhi8vc";
  };

  meta = {
    homepage = "https://github.com/madjar/nixbang";
    description = "Special shebang to run scripts in a nix-shell";
    mainProgram = "nixbang";
    maintainers = [ lib.maintainers.madjar ];
    platforms = lib.platforms.all;
  };
}
