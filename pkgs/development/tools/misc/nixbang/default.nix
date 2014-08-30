{ lib, pythonPackages, fetchgit }:

let version = "0.1.1"; in
pythonPackages.buildPythonPackage {
  name = "nixbang-${version}";
  namePrefix = "";

  src = fetchgit {
    url = "git://github.com/madjar/nixbang.git";
    rev = "refs/tags/${version}";
    sha256 = "1n8jq32r2lzk3g0d95ksfq7vdqciz34jabribrr4hcnz4nlijshf";
  };

  meta = {
    homepage = https://github.com/madjar/nixbang;
    description = "A special shebang to run scripts in a nix-shell";
    maintainers = [ lib.maintainers.madjar ];
    platforms = lib.platforms.all;
  };
}
