{ lib
, gomod2nix
, fetchFromGitHub
}:

gomod2nix.buildGoApplication {
  pname = "trillian";
  pwd = ./.;
  meta = {
    homepage = "https://github.com/google/trillian";
    description = "A transparent, highly scalable and cryptographically verifiable data store.";
    license = [ lib.licenses.asl20 ];
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
