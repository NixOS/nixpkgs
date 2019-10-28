{ stdenv, rustPlatform, fetchFromGitHub, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1iaib7yvxyn3l9kiys9x7wziixj13fmx1z3wgdy6h8c7jv6fpc0j";
  };

  cargoSha256 = "101p0qj7ydfhqfz402mxy4bs48vq3rzgj513f1kwv0ba4hn1sxkv";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with stdenv.lib; {
    description = "Executes commands in response to file modifications";
    homepage = https://github.com/watchexec/watchexec;
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
