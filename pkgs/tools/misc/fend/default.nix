{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, pandoc
, pkg-config
, openssl
, installShellFiles
, copyDesktopItems
, makeDesktopItem
, nix-update-script
, testers
, writeText
, runCommand
, fend
}:

rustPlatform.buildRustPackage rec {
  pname = "fend";
  version = "1.4.8";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = "fend";
    rev = "v${version}";
    hash = "sha256-i4h2QYgA1XX+qHOEH07PR3G/0SSA8a413vm9T39TuYQ=";
  };

  cargoHash = "sha256-EhumvDwXNXB0Vp3qWkJs0y0gEwiy3Z9/3KZ92YDTlqk=";

  nativeBuildInputs = [ pandoc installShellFiles pkg-config copyDesktopItems ];
  buildInputs = [ pkg-config openssl ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

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
    install -D -m 444 $src/icon/icon.svg $out/share/icons/hicolor/scalable/apps/fend.svg
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

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion { package = fend; };
      units = testers.testEqualContents {
        assertion = "fend does simple math and unit conversions";
        expected = writeText "expected" ''
          36 kph
        '';
        actual = runCommand "actual" { } ''
          ${lib.getExe fend} '(100 meters) / (10 seconds) to kph' > $out
        '';
      };
    };
  };

  meta = with lib; {
    description = "Arbitrary-precision unit-aware calculator";
    homepage = "https://github.com/printfn/fend";
    changelog = "https://github.com/printfn/fend/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ djanatyn liff ];
    mainProgram = "fend";
  };
}
