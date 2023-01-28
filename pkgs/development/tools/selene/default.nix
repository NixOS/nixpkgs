{ lib
, rustPlatform
, fetchFromGitHub
, robloxSupport ? true
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "selene";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "kampfkarren";
    repo = pname;
    rev = version;
    sha256 = "sha256-tw9OLdXhqxgqROub0P/+nd4LQGNw3QDxlCyyf8ogRQM=";
  };

  cargoSha256 = "sha256-5/xAX8BhB81cB7x2Pe/MKCV0Fi76ZcO6XHFQxTVIuLA=";

  nativeBuildInputs = lib.optionals robloxSupport [
    pkg-config
  ];

  buildInputs = lib.optionals robloxSupport [
    openssl
  ] ++ lib.optionals (robloxSupport && stdenv.isDarwin) [
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
