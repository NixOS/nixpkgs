{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "0pg3ahx8rmzr585qa4vphd1vxcm1r3sx5iyi8ghg5nn6sibqy0z4";
  };

  cargoSha256 = "0s7yld3cwmyfdsqwcipc2l07xx5qn3knjmh4bbnjmnxiygaiszx9";

  meta = with stdenv.lib; {
    description = "Find files with SQL-like queries";
    homepage = "https://github.com/jhspetersson/fselect";
    license = with licenses; [ asl20 mit ];
    maintainers = [ maintainers.filalex77 ];
    platforms = platforms.all;
  };
}
