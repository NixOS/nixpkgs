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
<<<<<<< HEAD
  version = "2.18.1";
=======
  version = "2.17.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-xa7LdIeeSzCoSUVe9CzC3hKDiKlQdr011+iF/WOVGx0=";
  };

  cargoHash = "sha256-zaRoL5fV0Vyca0Ay1WIl/1jAlPSeuoBevgrEFER6XJU=";
=======
    hash = "sha256-mIHaeEnMKOyEeEEkE5OZgQZWwFnm69GZui64iBZkfyo=";
  };

  cargoHash = "sha256-XFX3J/vgjboEu+xZWTkfo5jmZJkap1u3j9G9ewrzVqc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    maintainers = with maintainers; [ Br1ght0ne figsoda kloenk ];
=======
    maintainers = with maintainers; [ Br1ght0ne figsoda kloenk SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
