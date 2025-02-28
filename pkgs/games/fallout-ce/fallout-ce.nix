{
  callPackage,
  fetchFromGitHub,
  fetchpatch2,
}:

callPackage ./build.nix rec {
  pname = "fallout-ce";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "alexbatalov";
    repo = "fallout1-ce";
    rev = "v${version}";
    hash = "sha256-ZiBoF3SL00sN0QrD3fkWG9SAknumOvzRB1oQJff6ITA=";
  };

  patches = [
    # Fix case-sensitive filesystems issue when save/load games
    (fetchpatch2 {
      url = "https://github.com/alexbatalov/fallout1-ce/commit/aa3c5c1e3e3f9642d536406b2d8d6b362c9e402f.patch";
      sha256 = "sha256-quFRbKMS2pNDCNTWc1ZoB3jnB5qzw0b+2OeJUi8IPBc=";
    })
  ];

  extraMeta = {
    description = "Fully working re-implementation of Fallout, with the same original gameplay, engine bugfixes, and some quality of life improvements";
    homepage = "https://github.com/alexbatalov/fallout1-ce";
  };
}
