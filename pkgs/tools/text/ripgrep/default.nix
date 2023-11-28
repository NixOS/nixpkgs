{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, pkg-config
, Security
, withPCRE2 ? true
, pcre2
}:

rustPlatform.buildRustPackage rec {
  pname = "ripgrep";
  version = "14.0.2";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = pname;
    rev = version;
    hash = "sha256-r0o2hT5t4x7fmVVxE3x+vHQnEzY9E4nvLyZ4DDNCY9o=";
  };

  cargoHash = "sha256-J7vEeHSCQ4xbKMUOQ/lCcnnwmnKaz7neOvrY1pAVtXg=";

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optional withPCRE2 pkg-config;
  buildInputs = lib.optional withPCRE2 pcre2
    ++ lib.optional stdenv.isDarwin Security;

  buildFeatures = lib.optional withPCRE2 "pcre2";

  preFixup = ''
    $out/bin/rg --generate man > rg.1
    installManPage rg.1

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
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = with maintainers; [ globin ma27 zowoq ];
    mainProgram = "rg";
  };
}
