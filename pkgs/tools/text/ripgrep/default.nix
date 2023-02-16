{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, asciidoctor
, installShellFiles
, pkg-config
, Security
, withPCRE2 ? true
, pcre2
}:

rustPlatform.buildRustPackage rec {
  pname = "ripgrep";
  version = "13.0.0";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = pname;
    rev = version;
    sha256 = "0pdcjzfi0fclbzmmf701fdizb95iw427vy3m1svy6gdn2zwj3ldr";
  };

  cargoSha256 = "1kfdgh8dra4jxgcdb0lln5wwrimz0dpp33bq3h7jgs8ngaq2a9wp";

  auditable = true; # TODO: remove when this is the default

  nativeBuildInputs = [ asciidoctor installShellFiles ]
    ++ lib.optional withPCRE2 pkg-config;
  buildInputs = lib.optional withPCRE2 pcre2
    ++ lib.optional stdenv.isDarwin Security;

  buildFeatures = lib.optional withPCRE2 "pcre2";

  preFixup = ''
    installManPage $releaseDir/build/ripgrep-*/out/rg.1

    installShellCompletion $releaseDir/build/ripgrep-*/out/rg.{bash,fish}
    installShellCompletion --zsh complete/_rg
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
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = with maintainers; [ tailhook globin ma27 zowoq ];
    mainProgram = "rg";
  };
}
