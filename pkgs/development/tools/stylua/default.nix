{ fetchFromGitHub
, lib
, rustPlatform
, lua52Support ? true
, luauSupport ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ecv6am4JT4cJKAApieOWQZG3XZkeCpmLrs6K7+4c8xA=";
  };

  cargoSha256 = "sha256-r09fTZTmOZQCI3qIWcnQnhUXYLVK8pF5y0y/dQl88CI=";

  buildFeatures = lib.optional lua52Support "lua52"
    ++ lib.optional luauSupport "luau";

  meta = with lib; {
    description = "An opinionated Lua code formatter";
    homepage = "https://github.com/johnnymorganz/stylua";
    changelog = "https://github.com/johnnymorganz/stylua/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
