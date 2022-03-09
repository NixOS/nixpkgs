{ fetchFromGitHub
, lib
, rustPlatform
, lua52Support ? true
, luauSupport ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BPLN7/LaVDtCOJBgIJVbnENUyFtacRsK3JxDupytzOA=";
  };

  cargoSha256 = "sha256-MZsFbFQp5Rw20pXzvTFNhMiVx/TJZ63/2rU7vj7IcqQ=";

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
