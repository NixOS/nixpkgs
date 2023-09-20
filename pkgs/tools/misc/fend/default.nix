{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, pandoc
, installShellFiles
, copyDesktopItems
, makeDesktopItem
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "fend";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vV7P2e6kv6CCHbI5Roz9WElntl3t/5ySXUw3XXEXMv4=";
  };

  cargoHash = "sha256-oAkZHx33YrwRUUIoooqpy72QCq0ZkAgBZ8W8XDe2fNE=";

  nativeBuildInputs = [ pandoc installShellFiles copyDesktopItems ];
  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  postBuild = ''
    patchShebangs --build ./documentation/build.sh
    ./documentation/build.sh
  '';

  preFixup = ''
    installManPage documentation/fend.1
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    [[ "$($out/bin/fend "1 km to m")" = "1000 m" ]]
  '';

  postInstall = ''
    install -D -m 444 $src/icon/fend-icon-256.png $out/share/icons/hicolor/256x256/apps/fend.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "fend";
      desktopName = "fend";
      genericName = "Calculator";
      comment = "Arbitrary-precision unit-aware calculator";
      icon = "fend";
      exec = "fend";
      terminal = true;
      categories = [ "Utility" "Calculator" "ConsoleOnly" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Arbitrary-precision unit-aware calculator";
    homepage = "https://github.com/printfn/fend";
    license = licenses.mit;
    maintainers = with maintainers; [ djanatyn ];
    mainProgram = "fend";
  };
}
