{ fetchFromGitHub
, lib
, rustPlatform
, stdenvNoCC
, lua52Support ? true
, luauSupport ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = pname;
    rev = "v${version}";
    sha256 = "03w976fghqs2kswab5bridpr2p6hgldjyfd3l4kz0p5h98f3wzvf";
  };

  cargoSha256 = "1311ly02r6c2rqx0ssd6hpbw3sp0ffrf37bzdm66chxnh8cr83sj";

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
