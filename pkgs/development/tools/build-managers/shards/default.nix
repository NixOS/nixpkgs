{ stdenv, fetchFromGitHub, crystal }:

crystal.buildCrystalPackage rec {
  pname = "shards";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "crystal-lang";
    repo = "shards";
    rev = "v${version}";
    sha256 = "1bjy3hcdqq8769bx73f3pwn26rnkj23dngyfbw4iv32bw23x1d49";
  };

  # we cannot use `make` here as it would introduce a dependency on itself
  format = "crystal";

  shardsFile = ./shards.nix;

  crystalBinaries.shards.src = "./src/shards.cr";

  # tries to execute git which fails spectacularly
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Dependency manager for the Crystal language";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (crystal.meta) homepage platforms;
  };
}
