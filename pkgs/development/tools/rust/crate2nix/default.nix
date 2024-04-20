{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper

, cargo
, nix
, nix-prefetch-git
}:

rustPlatform.buildRustPackage rec {
  pname = "crate2nix";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = version;
    hash = "sha256-rGT3CW64cJS9nlnWPFWSc1iEa3dNZecVVuPVGzcsHe8=";
  };

  sourceRoot = "${src.name}/crate2nix";

  cargoHash = "sha256-YoE6wrQNQcRo/yaiVpASU2VOmHCPM4pDgTejn0ovOVY=";

  nativeBuildInputs = [ makeWrapper ];

  # Tests use nix(1), which tries (and fails) to set up /nix/var inside the
  # sandbox
  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/crate2nix \
        --suffix PATH ":" ${lib.makeBinPath [ cargo nix nix-prefetch-git ]}

    rm -rf $out/lib $out/bin/crate2nix.d
    mkdir -p \
      $out/share/bash-completion/completions \
      $out/share/zsh/vendor-completions
    $out/bin/crate2nix completions -s 'bash' -o $out/share/bash-completion/completions
    $out/bin/crate2nix completions -s 'zsh' -o $out/share/zsh/vendor-completions
  '';

  meta = with lib; {
    description = "A Nix build file generator for Rust crates.";
    mainProgram = "crate2nix";
    longDescription = ''
      Crate2nix generates Nix files from Cargo.toml/lock files
      so that you can build every crate individually in a Nix sandbox.
    '';
    homepage = "https://github.com/nix-community/crate2nix";
    license = licenses.asl20;
    maintainers = with maintainers; [ kolloch cole-h ];
    platforms = platforms.all;
  };
}

