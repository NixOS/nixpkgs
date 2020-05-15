{ stdenv
, fetchFromGitHub
, rustPlatform
, asciidoctor
, installShellFiles
, Security
, withPCRE2 ? true
, pcre2 ? null
}:

rustPlatform.buildRustPackage rec {
  pname = "ripgrep";
  version = "12.1.0";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = pname;
    rev = version;
    sha256 = "1vgkk78c25ia9y4q5psrh7xrlbfdn7dz7bc20kci40n8zr0vjwww";
  };

  cargoSha256 = "143lnf4yah9ik7v8rphv7gbvr2ckhjpmy8zfgqml1n3fqxiqvxnb";

  cargoBuildFlags = stdenv.lib.optional withPCRE2 "--features pcre2";

  nativeBuildInputs = [ asciidoctor installShellFiles ];
  buildInputs = (stdenv.lib.optional withPCRE2 pcre2)
  ++ (stdenv.lib.optional stdenv.isDarwin Security);

  preFixup = ''
    installManPage $releaseDir/build/ripgrep-*/out/rg.1

    installShellCompletion $releaseDir/build/ripgrep-*/out/rg.{bash,fish}
    installShellCompletion --zsh "$src/complete/_rg"
  '';

  meta = with stdenv.lib; {
    description = "A utility that combines the usability of The Silver Searcher with the raw speed of grep";
    homepage = "https://github.com/BurntSushi/ripgrep";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = with maintainers; [ tailhook globin ma27 ];
    platforms = platforms.all;
  };
}
