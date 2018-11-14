{ stdenv, fetchFromGitHub, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  name = "hyperfine-${version}";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "hyperfine";
    rev    = "refs/tags/v${version}";
    sha256 = "06kghk3gmi47c8g28n8srpb578yym104fa30s4m33ajb60fvwlld";
  };

  cargoSha256 = "1rwh8kyrkk5jza4lx7sf1pln68ljwsv4ccyfvzcvc140y7ya8ps0";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Command-line benchmarking tool";
    homepage    = https://github.com/sharkdp/hyperfine;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.thoughtpolice ];
    platforms   = platforms.all;
  };
}
