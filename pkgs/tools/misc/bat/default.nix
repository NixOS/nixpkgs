{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, less
, Security
, libiconv
, installShellFiles
, makeWrapper
, fetchpatch
}:

rustPlatform.buildRustPackage rec {
  pname = "bat";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xkGGnWjuZ5ZR4Ll+JwgWyKZFboFZ6HKA8GviR3YBAnM=";
  };
  cargoSha256 = "sha256-ye6GH4pcI9h1CNpobUzfJ+2WlqJ98saCdD77AtSGafg=";

  cargoPatches = [
    # merged upstream in https://github.com/sharkdp/bat/pull/2399
    (fetchpatch {
      name = "disable-completion-of-cache-subcommand.patch";
      url = "https://github.com/sharkdp/bat/commit/b6b9d3a629bd9b08725df2a4e7b92c3023584a89.patch";
      hash = "sha256-G4LajO09+qfhpr+HRvAHCuE9EETit2e16ZEyAtz26B4=";
      excludes = [ "CHANGELOG.md" ];
    })
  ];

  nativeBuildInputs = [ pkg-config installShellFiles makeWrapper ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv ];

  postInstall = ''
    installManPage $releaseDir/build/bat-*/out/assets/manual/bat.1
    installShellCompletion $releaseDir/build/bat-*/out/assets/completions/bat.{bash,fish,zsh}
  '';

  # Insert Nix-built `less` into PATH because the system-provided one may be too old to behave as
  # expected with certain flag combinations.
  postFixup = ''
    wrapProgram "$out/bin/bat" \
      --prefix PATH : "${lib.makeBinPath [ less ]}"
  '';

  checkFlags = [ "--skip=pager_more" "--skip=pager_most" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    testFile=$(mktemp /tmp/bat-test.XXXX)
    echo -ne 'Foobar\n\n\n42' > $testFile
    $out/bin/bat -p $testFile | grep "Foobar"
    $out/bin/bat -p $testFile -r 4:4 | grep 42
    rm $testFile

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage = "https://github.com/sharkdp/bat";
    changelog = "https://github.com/sharkdp/bat/raw/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir lilyball zowoq SuperSandro2000 ];
  };
}
