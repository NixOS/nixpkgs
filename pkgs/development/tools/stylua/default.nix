{ fetchFromGitHub
, lib
, rustPlatform
, stdenvNoCC
, lua52Support ? true
, luauSupport ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = pname;
    rev = "v${version}";
    sha256 = "12vflwk1h5ahamxiiaznx3k1ldi8il0adwb2rl58swmvfzbcm7y9";
  };

  cargoSha256 = "1glkfxz9apmsqbyl8fy5gwywbr6k7cv0l47w2nfimg92qn9xzgks";

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
