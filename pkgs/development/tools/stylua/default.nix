{ fetchFromGitHub
, lib
, rustPlatform
, lua52Support ? true
, luauSupport ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FqtpMRR647YiIIduIf37rKewytXgRl01OCmBUXd/44k=";
  };

  cargoSha256 = "sha256-Z5W1eJUHFFuHRSemXspW3gUhiAieyUg/6lIVvqAL/Oo=";

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
