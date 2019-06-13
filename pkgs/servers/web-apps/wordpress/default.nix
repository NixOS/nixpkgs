  # Upgrading? We have a test! nix-build ./nixos/tests/wordpress.nix
{ fetchFromGitHub, lib } : fetchFromGitHub {
  owner = "WordPress";
  repo = "WordPress";
  rev = "5.0.2";
  sha256 = "1r8y62mdv6ji82hcn94gngi68mwilxh69gpx8r83k0cy08s99sln";
  meta = {
    homepage = https://wordpress.org;
    description = "WordPress is open source software you can use to create a beautiful website, blog, or app.";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.basvandijk ];
  };
}
