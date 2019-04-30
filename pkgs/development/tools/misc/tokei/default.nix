{ stdenv, fetchFromGitHub, rustPlatform, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "tokei";
  version = "9.1.1";

  src = fetchFromGitHub {
    owner = "XAMPPRocky";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gz8m5j9p7hwylyl7cdxbli9rpy1p6lsrbym4zk647819pg4k1jp";
  };

  cargoSha256 = "1xai3jxvs8r3s3v5d5w40miw6nihnj9gzlzzdrwphmgrkywr88c4";

  buildInputs = [ libiconv ];

  meta = with stdenv.lib; {
    description = "Program that displays statistics about your code";
    homepage = https://github.com/XAMPPRocky/tokei;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
