{ stdenv, fetchFromGitHub, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-cache";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "matthiaskrgr";
    repo = pname;
    rev = version;
    sha256 = "02d593w1x8160p4m3jwm1dyvv383cy7njijlcaw49jczxv5isqbi";
  };

  cargoSha256 = "150ifd7gq6csrasqw91z4nsaj6w7kf69j0w6wydr3z7bdahmlgqw";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  checkFlagsArray = [ "offline_tests" ];

  meta = with stdenv.lib; {
    description = "Manage cargo cache (\${CARGO_HOME}, ~/.cargo/), print sizes of dirs and remove dirs selectively";
    homepage = "https://github.com/matthiaskrgr/cargo-cache";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ filalex77 ];
  };
}
