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
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-An1biuaqPeRniJZroxoT2o9IEA4XFf5l6ut4nmOsQJI=";
  };

  cargoHash = "sha256-gnFu0JsMt1wMfifF6EnjDwwydFnVyqpkHV0cyR5Qt3Y=";

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
    maintainers = with maintainers; [ djanatyn liff ];
    mainProgram = "fend";
  };
}
