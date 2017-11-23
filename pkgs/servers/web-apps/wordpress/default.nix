  # Upgrading? We have a test! nix-build ./nixos/tests/wordpress.nix
{ fetchFromGitHub, lib } : fetchFromGitHub {
  owner = "WordPress";
  repo = "WordPress";
  rev = "4.9";
  sha256 = "1qffh413k8c1mf3jj9hys3a7y1qfjcg2w96w4c9x3ida3lchg7ln";
  meta = {
    homepage = https://wordpress.org;
    description = "WordPress is open source software you can use to create a beautiful website, blog, or app.";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.basvandijk ];
  };
}
