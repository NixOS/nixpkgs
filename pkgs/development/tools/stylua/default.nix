{ fetchFromGitHub
, lib
, rustPlatform
, stdenvNoCC
, lua52Support ? true
, luauSupport ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+5c8baeToaT4k/2VSK/XQki0NPsWTnS6Ap3NpWvj+yI=";
  };

  cargoSha256 = "sha256-uIcP5ZNb8K5pySw0Qq46hev9VUbq8XVqmzBBGPagUfE=";

  cargoBuildFlags = lib.optionals lua52Support [ "--features" "lua52" ]
    ++ lib.optionals luauSupport [ "--features" "luau" ];

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
