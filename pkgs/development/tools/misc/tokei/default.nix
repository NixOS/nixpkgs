{ stdenv, fetchFromGitHub, rustPlatform, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "tokei";
  version = "11.1.0";

  src = fetchFromGitHub {
    owner = "XAMPPRocky";
    repo = pname;
    rev = "v${version}";
    sha256 = "11nmh2b7pal67nhcygp5gpzf3n158671fjjxw0vwjgrb87hkdry9";
  };

  cargoSha256 = "1axfkyghf6gzv24is4n6kgc28nx0d6laqpdv7j1xzkf6hdixkch7";

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
