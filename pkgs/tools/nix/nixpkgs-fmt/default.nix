{ lib, rustPlatform, fetchFromGitHub, fetchpatch }:
rustPlatform.buildRustPackage rec {
  pname = "nixpkgs-fmt";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "09lhi8aidw9qf94n07mgs2nfac32a96wkx50glj35dhn06iwzwqr";
  };

  patches = [
    # Fixes debug output on stdout mangling some files. Fixed in next release.
    # https://github.com/nix-community/nixpkgs-fmt/issues/201
    (fetchpatch {
      url = "https://github.com/nix-community/nixpkgs-fmt/commit/648f46e1d5507592b246311618f467da282bf1b5.patch";
      sha256 = "18n4criyl0lydxmjqfkcmwx0pniyqzfgfxcjwz6czqwmx5y7b4rb";
    })
  ];

  cargoSha256 = "15m40d9354412h51zn806pxsqjai48xiw8chf8slbi0cjxd268j9";

  meta = with lib; {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}
