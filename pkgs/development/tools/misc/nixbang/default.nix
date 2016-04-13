{ lib, pythonPackages, fetchFromGitHub }:

let version = "0.1.2"; in
pythonPackages.buildPythonApplication {
  name = "nixbang-${version}";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "madjar";
    repo = "nixbang";
    rev = version;
    sha256 = "1kzk53ry60i814wa6n9y2ni0bcxhbi9p8gdv10b974gf23mhi8vc";
  };

  meta = {
    homepage = https://github.com/madjar/nixbang;
    description = "A special shebang to run scripts in a nix-shell";
    maintainers = [ lib.maintainers.madjar ];
    platforms = lib.platforms.all;
  };
}
