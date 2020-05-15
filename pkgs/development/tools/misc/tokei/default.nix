{ stdenv, fetchFromGitHub, rustPlatform, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "tokei";
  version = "11.1.1";

  src = fetchFromGitHub {
    owner = "XAMPPRocky";
    repo = pname;
    rev = "v${version}";
    sha256 = "1sribqcyalgl66im92pmla0hnp07zvg3pbxxakm7jk5l6p13wiw3";
  };

  cargoSha256 = "0jcy3p896ykc6s3m21pnh4jv4lhpvhzlrrl1y67ink2lqkamdhvv";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [
    libiconv darwin.apple_sdk.frameworks.Security
  ];

  # enable all output formats
  cargoBuildFlags = [ "--features" "all" ];

  meta = with stdenv.lib; {
    description = "A program that allows you to count your code, quickly";
    longDescription = ''
      Tokei is a program that displays statistics about your code. Tokei will show number of files, total lines within those files and code, comments, and blanks grouped by language.
    '';
    homepage = "https://github.com/XAMPPRocky/tokei";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gebner lilyball ];
    platforms = platforms.all;
  };
}
