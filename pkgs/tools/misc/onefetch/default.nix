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
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = version;
    hash = "sha256-aQeKzOxRlSGuVewh3HEx1M12vmaxhy6ImnqMDc5b0DI=";
  };

  cargoHash = "sha256-g+fTmZGyPkQLgnJ9Bb4sLTfDMPPBRA+s6f3OxXTKwsM=";

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
    maintainers = with maintainers; [ Br1ght0ne figsoda kloenk ];
    mainProgram = "onefetch";
  };
}
