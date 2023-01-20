{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
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
  version = "2.13.2";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ydRdnzOI9syfF2ox9vHA9Q0j8C7ZNb0b7CJfqUprPA0=";
  };

  cargoSha256 = "sha256-IprUSNxoojagXUO/I7WDGJMG0U541ioe4qgLT4hqmbY=";

  cargoPatches = [
    # enable pkg-config feature of zstd
    ./zstd-pkg-config.patch
  ];

  patches = [
    (fetchpatch {
      name = "use-iso-time-for-snapshot-tests";
      url = "https://github.com/o2sh/onefetch/commit/b8b0320d2d271bb10053403092833a26e57134d1.patch";
      hash = "sha256-LnC+UCvSwMePC4jBjrTKnbyypNvHHNevB2v4y+hv8Pc=";
    })
  ];

  nativeBuildInputs = [ cmake installShellFiles pkg-config ];

  buildInputs = [ zstd ]
    ++ lib.optionals stdenv.isDarwin [ CoreFoundation libresolv Security ];

  checkInputs = [
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
