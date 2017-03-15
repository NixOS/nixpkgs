  # Upgrading? We have a test! nix-build ./nixos/tests/wordpress.nix
{ fetchFromGitHub, lib } : fetchFromGitHub {
  owner = "WordPress";
  repo = "WordPress";
  rev = "4.7.3";
  sha256 = "05gggm40065abylp6bdc0zn0q6ahcggyh4q6rk0ak242q8v5fm5b";
  meta = {
    homepage = https://wordpress.org;
    description = "WordPress is open source software you can use to create a beautiful website, blog, or app.";
    license = lib.licenses.gpl2;
  };
}
