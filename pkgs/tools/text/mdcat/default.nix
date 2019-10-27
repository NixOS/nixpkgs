{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, Security, ansi2html }:

rustPlatform.buildRustPackage rec {
  pname = "mdcat";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lunaryorn";
    repo = pname;
    rev = "mdcat-${version}";
    sha256 = "0xlcpyfmil7sszv4008v4ipqswz49as4nzac0kzmzsb86np191q0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ (stdenv.lib.optional stdenv.isDarwin Security) openssl ];

  cargoSha256 = "16q17gm59lpjqa18q289cjmjlf2jicag12jz529x5kh11x6bjl8v";

  checkInputs = [ ansi2html ];
  checkPhase = ''
    # Skip tests that use the network.
    cargo test -- --skip terminal::iterm2
  '';

  meta = with stdenv.lib; {
    description = "cat for markdown";
    homepage = https://github.com/lunaryorn/mdcat;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.all;
  };
}
