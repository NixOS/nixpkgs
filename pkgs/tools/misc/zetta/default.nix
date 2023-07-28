{ lib
, gitSupport ? true
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, pandoc
, pkg-config
, zlib
, Security
, libiconv
, installShellFiles
}:

rustPlatform.buildRustPackage {
  pname = "zetta";
  version = "unstable-2023-06-16";

  src = fetchFromGitHub {
    owner = "syphar";
    repo = "zetta";
    rev = "0f39fffa164b62d97d599cd718bee81ca080ed56";
    hash = "sha256-2pNp1AHPZCvLt5de8+OJfazi8WmApLbPMgCF/kIXV90=";
  };

  cargoHash = "sha256-qgZhp6EkgSma/hdakaE65VkH4UbwLkxav7a9xnWJDhs=";

  nativeBuildInputs = [ cmake pkg-config installShellFiles pandoc ];
  buildInputs = [ zlib ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional gitSupport "git";

  outputs = [ "out" "man" ];

  # BLOCKED: upstream has to update man/exa.1.md to man/zetta.1.md etc.
  # BLOCKED: upstream has to update completions
  postInstall = ''
    pandoc --standalone -f markdown -t man man/exa.1.md > man/zetta.1
    pandoc --standalone -f markdown -t man man/exa_colors.5.md > man/zetta_colors.5
    installManPage man/zetta.1 man/zetta_colors.5
    # installShellCompletion \
    #   --bash completions/bash/exa \
    #   --fish completions/fish/exa.fish \
    #   --zsh completions/zsh/_exa
  '';

  meta = with lib; {
    description = "Replacement for 'ls' written in Rust";
    longDescription = ''
      zetta builds on the awesome foundation of exa so we can add more features.
      When exa becomes maintained again, features could be merged back.
    '';
    changelog = "https://github.com/syphar/zetta/releases";
    homepage = "https://github.com/syphar/zetta";
    license = licenses.mit;
    maintainers = with maintainers; [ cafkafk ];
  };
}
