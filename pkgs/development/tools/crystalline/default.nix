{ lib, fetchFromGitHub, crystal, }:

crystal.buildCrystalPackage rec {
  version = "0.7.0";
  pname = "crystalline";

  src = fetchFromGitHub {
    ownerr = "elbywan";
    repo = pname;
    rev = "v${version}";
    sha256 = "";
  };

  postPatch = ''
    export HOME=$TMP
  '';

  format = "shards";

  # Update with
  #   nix-shell -p crystal2nix --run
  # with crystalline's shard.lock file in the current directory
  shardsFile = ./shards.nix;

  crystalBinaries.pname.src = "src/${pname}.cr";

  meta = with lib; {
    description = "A Language Server for Crystal";
    homepage = "https://github.com/elbywan/crystalline";
    license = licenses.mit;
    maintainers = with maintainers; [ annaaurora ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    #broken = lib.versionOlder crystal.version "1.0";
  };
}
