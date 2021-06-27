{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "gptman";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "cecton";
    repo = pname;
    rev = "v${version}";
    sha256 = "11zyjrw4f8gi5s4sd2kl3sdiz0avq7clr8zqnwl04y61b3fpg7y1";
  };

  cargoSha256 = "1cp8cyrd7ab8r2j28b69c2p3ysix5b9hpsqk07cmzgqwwml0qj12";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "A CLI tool for Linux to copy a partition from one disk to another and more.";
    homepage = "https://github.com/cecton/gptman";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ akshgpt7 ];
  };
}
