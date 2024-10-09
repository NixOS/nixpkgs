{ stdenv
, lib
, darwin
, rustPlatform
, fetchFromGitHub
, jq
, moreutils
, nix-update-script
, withCmd ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.7.0-prerelease-1";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eDeGVmh1gI/DhiP6gxJyGH9G9LNH1NHW0+DNuOPUnBY=";
  };

  cargoHash = "sha256-Om9Thyr10wc39J6adSWgmXtvjckaEW0z68sWxUqa4wc=";

  # the dependency native-windows-gui contains both README.md and readme.md,
  # which causes a hash mismatch on systems with a case-insensitive filesystem
  # this removes the readme files and updates cargo's checksum file accordingly
  depsExtraArgs = {
    nativeBuildInputs = [
      jq
      moreutils
    ];

    postBuild = ''
      pushd $name/native-windows-gui

      rm --force --verbose README.md readme.md
      jq 'del(.files."README.md") | del(.files."readme.md")' \
        .cargo-checksum.json -c \
        | sponge .cargo-checksum.json

      popd
    '';
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.IOKit ];

  buildFeatures = lib.optional withCmd "cmd";

  postInstall = ''
    install -Dm 444 assets/kanata-icon.svg $out/share/icons/hicolor/scalable/apps/kanata.svg
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ bmanuel linj ];
    platforms = platforms.unix;
    mainProgram = "kanata";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
