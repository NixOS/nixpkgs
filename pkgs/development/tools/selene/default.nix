{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, robloxSupport ? true
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "selene";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "kampfkarren";
    repo = pname;
    rev = version;
    sha256 = "sha256-gD49OzhpO059wawA+PJc8SIYQ23965LF21zqIfj62Y4=";
  };

  cargoSha256 = "sha256-oekqM/Jvh0z6O6iJhSi7Ph5gsF5Fssr5ItKpmyozhPk=";

  patches = [
    # fix broken test
    # https://github.com/kampfkarren/selene/pull/471
    (fetchpatch {
      name = "fix-test-roblox-incorrect-roact-usage.patch";
      url = "https://github.com/kampfkarren/selene/commit/f4abf9f3fb639b372fe4ac47449f8a1e455c28a5.patch";
      sha256 = "sha256-nk7HGygXXu91cqiRZBA/sLBlaJLkNg90C2NX8Kr1WGA=";
    })
  ];

  nativeBuildInputs = lib.optionals robloxSupport [
    pkg-config
  ];

  buildInputs = lib.optionals robloxSupport [
    openssl
  ] ++ lib.optional (robloxSupport && stdenv.isDarwin) [
    darwin.apple_sdk.frameworks.Security
  ];

  buildNoDefaultFeatures = !robloxSupport;

  meta = with lib; {
    description = "A blazing-fast modern Lua linter written in Rust";
    homepage = "https://github.com/kampfkarren/selene";
    changelog = "https://github.com/kampfkarren/selene/blob/${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
