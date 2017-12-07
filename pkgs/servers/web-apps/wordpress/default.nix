  # Upgrading? We have a test! nix-build ./nixos/tests/wordpress.nix
{ fetchFromGitHub, lib } : fetchFromGitHub {
  owner = "WordPress";
  repo = "WordPress";
  rev = "4.8.3";
  sha256 = "077bdx22sj29v8q493b49xfzxpc38q45pjhmn4znw2fmkjilih5p";
  meta = {
    homepage = https://wordpress.org;
    description = "WordPress is open source software you can use to create a beautiful website, blog, or app.";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.basvandijk ];
  };
}
