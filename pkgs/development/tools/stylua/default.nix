{ fetchFromGitHub, lib, rustPlatform, stdenvNoCC, lua52Support ? true
, luauSupport ? false }:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rdtFzHpOvv1uJBigJWenWyIZF/wpYP7iBW2FCsfq2d4=";
  };

  cargoSha256 = "sha256-/4ZW1FIfK51ak2EIV6dYY3XpucPPR+OZySPWwcKP4v0=";

  buildFeatures = lib.optional lua52Support "lua52"
    ++ lib.optional luauSupport "luau";

  # test_standard fails on darwin
  doCheck = !stdenvNoCC.isDarwin;

  meta = with lib; {
    description = "An opinionated Lua code formatter";
    homepage = "https://github.com/johnnymorganz/stylua";
    changelog =
      "https://github.com/johnnymorganz/stylua/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
