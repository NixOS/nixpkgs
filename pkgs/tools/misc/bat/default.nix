{ stdenv, rustPlatform, fetchFromGitHub, pkg-config, less, Security, libiconv
, installShellFiles, makeWrapper, writeScript, common-updater-scripts, git
, nixfmt, nix, coreutils, gnused, gnugrep, gawk }:

rustPlatform.buildRustPackage rec {
  pname = "bat";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "161pfix42j767ziyp4mslffdd20v9i0ncplvjw2pmpccwdm106kg";
  };

  cargoSha256 = "19vhhxfyx3nrngcs6dvwldnk9h4lvs7xjkb31aj1y0pyawz882h9";

  nativeBuildInputs = [ pkg-config installShellFiles makeWrapper ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security libiconv ];

  postInstall = ''
    installManPage $releaseDir/build/bat-*/out/assets/manual/bat.1
    installShellCompletion $releaseDir/build/bat-*/out/assets/completions/bat.{fish,zsh}
  '';

  # Insert Nix-built `less` into PATH because the system-provided one may be too old to behave as
  # expected with certain flag combinations.
  postFixup = ''
    wrapProgram "$out/bin/bat" \
      --prefix PATH : "${stdenv.lib.makeBinPath [ less ]}"
  '';

  passthru = {
    updateScript = writeScript "update.sh" ''
      #!${stdenv.shell}
      set -o errexit
      PATH=${
        stdenv.lib.makeBinPath [
          common-updater-scripts
          git
          nixfmt
          nix
          coreutils
          gnused
          gnugrep
          gawk
        ]
      }

      oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion ${pname}" | tr -d '"')"
      latestTag="$(git -c 'versionsort.suffix=-' ls-remote --exit-code --refs --sort='version:refname' --tags git@github.com:sharkdp/bat.git '*' | tail --lines=1 | cut --delimiter='/' --fields=3 | sed 's|^v||g')"

      if [ ! "$oldVersion" = "$latestTag" ]; then
        update-source-version ${pname} "$latestTag" --version-key=version --print-changes
        nixpkgs="$(git rev-parse --show-toplevel)"
        default_nix="$nixpkgs/pkgs/tools/misc/bat/default.nix"
        dummy_cargo="19vhhxfyx3nrngcs6dvwldnk9h4lvs7xjkb31aj1y0pyawz882h9"
        old_cargo=$(grep '^\s*cargoSha256 = ' pkgs/tools/misc/bat/default.nix | awk -F= '{print $2}' | tr -d '" ;')
        sed -i "s|$old_cargo|$dummy_cargo|g" "$default_nix"
        new_cargo=$(nix-build -A bat 2>&1 | grep sha256 | grep got | awk -F: '{print $3}')
        sed -i "s|$dummy_cargo|$new_cargo|g" "$default_nix"
        nixfmt "$default_nix"
      else
        echo "${pname} is already up-to-date"
      fi
    '';
  };

  meta = with stdenv.lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage = "https://github.com/sharkdp/bat";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ dywedir lilyball nequissimus zowoq ];
  };
}
