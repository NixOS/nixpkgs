{ stdenv
, fetchFromGitHub
, rustPlatform
, asciidoc
, docbook_xsl
, libxslt
, installShellFiles
, Security
, withPCRE2 ? true
, pcre2 ? null
}:

rustPlatform.buildRustPackage rec {
  pname = "ripgrep";
  version = "12.0.0";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = pname;
    rev = version;
    sha256 = "0n4169l662fvg6r4rcfs8n8f92rxndlaqb7k4x63680mra470dbi";
  };

  cargoSha256 = "01zi9zqdjsgc3im9na511n6w2bmqvm46wryh10fhzc9fnkziqmq3";

  cargoBuildFlags = stdenv.lib.optional withPCRE2 "--features pcre2";

  nativeBuildInputs = [ asciidoc docbook_xsl libxslt installShellFiles ];
  buildInputs = (stdenv.lib.optional withPCRE2 pcre2)
  ++ (stdenv.lib.optional stdenv.isDarwin Security);

  preFixup = ''
    (cd target/release/build/ripgrep-*/out
    installManPage rg.1
    installShellCompletion rg.{bash,fish})
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
