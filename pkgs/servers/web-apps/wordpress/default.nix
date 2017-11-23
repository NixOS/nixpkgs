  # Upgrading? We have a test! nix-build ./nixos/tests/wordpress.nix
{ fetchFromGitHub, lib } : fetchFromGitHub {
  owner = "WordPress";
  repo = "WordPress";
  rev = "4.7.6";
  sha256 = "0da44nqb6ny0r2z9m93zvigxzjz1k1ggxfc1320yy3f77ini82jr";
  meta = {
    homepage = https://wordpress.org;
    description = "WordPress is open source software you can use to create a beautiful website, blog, or app.";
    license = lib.licenses.gpl2;
  };
}
