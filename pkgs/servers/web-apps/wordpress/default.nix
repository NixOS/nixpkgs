  # Upgrading? We have a test! nix-build ./nixos/tests/wordpress.nix
{ fetchFromGitHub, lib } : fetchFromGitHub {
  owner = "WordPress";
  repo = "WordPress";
  rev = "4.9.1";
  sha256 = "0d931mv6wbgnc7f15nisnn5al0ffi19zya2iwdzw98s4klpaq955";
  meta = {
    homepage = https://wordpress.org;
    description = "WordPress is open source software you can use to create a beautiful website, blog, or app.";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.basvandijk ];
  };
}
