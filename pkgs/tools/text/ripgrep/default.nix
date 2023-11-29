{ lib, stdenv
, buildPackages
, fetchFromGitHub
, rustPlatform
, installShellFiles
, pkg-config
, Security
, withPCRE2 ? true
, pcre2
, enableManpages ? stdenv.hostPlatform.emulatorAvailable buildPackages
}:

rustPlatform.buildRustPackage rec {
  pname = "ripgrep";
  version = "14.0.3";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = pname;
    rev = version;
    hash = "sha256-NBGbiy+1AUIBJFx6kcGPSKo08a+dkNo4rNH2I1pki4U=";
  };

  cargoHash = "sha256-s6oK0/eL+NAhG3ySUlJBRatUuWXxfRVgAvlJm++0lkg=";

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optional withPCRE2 pkg-config;
  buildInputs = lib.optional withPCRE2 pcre2
    ++ lib.optional stdenv.isDarwin Security;

  buildFeatures = lib.optional withPCRE2 "pcre2";

  preFixup = lib.optionalString enableManpages ''
    ${stdenv.hostPlatform.emulator buildPackages} $out/bin/rg --generate man > rg.1
    installManPage rg.1
  '' + ''
    installShellCompletion --cmd rg \
      --bash <($out/bin/rg --generate complete-bash) \
      --fish <($out/bin/rg --generate complete-fish) \
      --zsh <($out/bin/rg --generate complete-zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    file="$(mktemp)"
    echo "abc\nbcd\ncde" > "$file"
    $out/bin/rg -N 'bcd' "$file"
    $out/bin/rg -N 'cd' "$file"
  '' + lib.optionalString withPCRE2 ''
    echo '(a(aa)aa)' | $out/bin/rg -P '\((a*|(?R))*\)'
  '';

  meta = with lib; {
    description = "A utility that combines the usability of The Silver Searcher with the raw speed of grep";
    homepage = "https://github.com/BurntSushi/ripgrep";
    changelog = "https://github.com/BurntSushi/ripgrep/releases/tag/${version}";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = with maintainers; [ globin ma27 zowoq ];
    mainProgram = "rg";
  };
}
