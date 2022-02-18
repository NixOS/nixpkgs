{ fetchFromGitHub
, lib
, rustPlatform
, stdenvNoCC
, lua52Support ? true
, luauSupport ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bgfG1cPhauU85FG/ZX1n2KqfydMeh92q347UsREkOGo=";
  };

  cargoSha256 = "sha256-njZTD6O67v787Z1tJ7G0QzxJLhqU2sfpOVw6r4woE9s=";

  buildFeatures = lib.optional lua52Support "lua52"
    ++ lib.optional luauSupport "luau";

  # test_standard fails on darwin
  doCheck = !stdenvNoCC.isDarwin;

  meta = with lib; {
    description = "An opinionated Lua code formatter";
    homepage = "https://github.com/johnnymorganz/stylua";
    changelog = "https://github.com/johnnymorganz/stylua/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
