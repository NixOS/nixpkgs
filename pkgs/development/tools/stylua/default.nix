{ fetchFromGitHub
, lib
, rustPlatform
, stdenvNoCC
, lua52Support ? true
, luauSupport ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = pname;
    rev = "v${version}";
    sha256 = "0idx4664p9ggv8p2pwgpch42li9ksiilszpwva19y4fa5xrmcyr2";
  };

  cargoSha256 = "1hc7zvrfiiijk4wr6i5jk6k32nz0lf64gqin3n8b8x5pp9d8fcfk";

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
