{ luarocks
, fetchFromGitHub
, unstableGitUpdater
, nurl
, file
}:

luarocks.overrideAttrs (old: {
  pname = "luarocks-nix";
  version = "nix_v3.5.0-1-unstable-2024-04-28";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks-nix";
    rev = "a473a8f479711682f5b97a72362736d96efd463b";
    sha256 = "sha256-hsjv+jlLsoIDM4gB/0mFeoVu1YZ1I9ELDALLTEnlCF0=";
  };

  propagatedBuildInputs = old.propagatedBuildInputs ++ [
    file
    nurl
  ];

  patches = [ ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };
})
