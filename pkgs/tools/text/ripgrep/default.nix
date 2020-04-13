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
  version = "12.0.1";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = pname;
    rev = version;
    sha256 = "1c0v51s05kbg9825n6mvpizhkkgz38wl7hp8f3vzbjfg4i8l8wb0";
  };

  cargoSha256 = "0i8x2xgri8f8mzrlkc8l2yzcgczl35nw4bmwg09d343mjkmk6d8y";

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
