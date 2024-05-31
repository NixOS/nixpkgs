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
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "kampfkarren";
    repo = pname;
    rev = version;
    sha256 = "sha256-NbVSFYv3nyEjSf0bFajcMaoWP2bS0EfJT8tDddjS7jg=";
  };

  cargoHash = "sha256-e3oQUFtgdjqPiB2YpmqnFUG2scmYJhLSpUaw0W6RxIk=";

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
    mainProgram = "selene";
    homepage = "https://github.com/kampfkarren/selene";
    changelog = "https://github.com/kampfkarren/selene/blob/${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
