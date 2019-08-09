{ stdenv, rustPlatform, fetchFromGitHub, CoreServices, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0iaxicghvfy85hrxn151hz8frgfknk3s1z0ngjn7cv5x5zvfxspf";
  };

  cargoSha256 = "1sqwplvpg0n9j0h9j94m7a6ylgqi4y4wyx489y09z9gm7aqgrsjc";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with stdenv.lib; {
    description = "Executes commands in response to file modifications";
    homepage = https://github.com/watchexec/watchexec;
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
