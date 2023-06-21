{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, installShellFiles
, pkg-config
, zstd
, stdenv
, CoreFoundation
, libresolv
, Security
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "onefetch";
  version = "2.18.0";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = version;
    hash = "sha256-XjsKdfz4uQ1W8ul/2dbKiz7oVksUv5UNBF0U0MNsUPs=";
  };

  cargoHash = "sha256-G7cJoUxkOn6pQtRwzI8/KFvvbkN8JLgZcdUUZffIydo=";

  cargoPatches = [
    # enable pkg-config feature of zstd
    ./zstd-pkg-config.patch
  ];

  nativeBuildInputs = [ cmake installShellFiles pkg-config ];

  buildInputs = [ zstd ]
    ++ lib.optionals stdenv.isDarwin [ CoreFoundation libresolv Security ];

  nativeCheckInputs = [
    git
  ];

  preCheck = ''
    git init
    git config user.name nixbld
    git config user.email nixbld@example.com
    git add .
    git commit -m test
  '';

  postInstall = ''
    installShellCompletion --cmd onefetch \
      --bash <($out/bin/onefetch --generate bash) \
      --fish <($out/bin/onefetch --generate fish) \
      --zsh <($out/bin/onefetch --generate zsh)
  '';

  meta = with lib; {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    changelog = "https://github.com/o2sh/onefetch/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne figsoda kloenk SuperSandro2000 ];
  };
}
