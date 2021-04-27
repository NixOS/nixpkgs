{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, asciidoctor
, installShellFiles
, pkg-config
, Security
, withPCRE2 ? true
, pcre2 ? null
}:

rustPlatform.buildRustPackage rec {
  pname = "ripgrep";
  version = "12.1.1";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = pname;
    rev = version;
    sha256 = "1hqps7l5qrjh9f914r5i6kmcz6f1yb951nv4lby0cjnp5l253kps";
  };

  cargoSha256 = "03wf9r2csi6jpa7v5sw5lpxkrk4wfzwmzx7k3991q3bdjzcwnnwp";

  cargoBuildFlags = lib.optional withPCRE2 "--features pcre2";

  nativeBuildInputs = [ asciidoctor installShellFiles ]
    ++ lib.optional withPCRE2 pkg-config;
  buildInputs = (lib.optional withPCRE2 pcre2)
    ++ (lib.optional stdenv.isDarwin Security);

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
