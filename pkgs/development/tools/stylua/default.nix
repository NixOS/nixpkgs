{ fetchFromGitHub
, lib
, rustPlatform
, stdenvNoCC
, lua52Support ? true
, luauSupport ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ihb6hq1va6nj7d2883m9gdhzrwmcsw7z0fxqkhs9scv4i9x6s9d";
  };

  cargoSha256 = "04gm9drb4qh1sdzqqdj3lwb462y22sz24gjr6nw3sd2a0iqhsknf";

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
