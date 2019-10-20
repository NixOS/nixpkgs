{ stdenv, fetchFromGitHub, rustPlatform, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "tokei";
  version = "10.0.1";

  src = fetchFromGitHub {
    owner = "XAMPPRocky";
    repo = pname;
    rev = "v${version}";
    sha256 = "0g8p4f8g9zb1fqzzb1qi28idskahi5nldsma6rydjyrgi9gynpa0";
  };

  cargoSha256 = "0pwq1scll5ga8rw4lx97s915zvp7v171b6316cin54f2zzpbrxx5";

  # Patch for v10.0.1 Cargo.lock issue
  patches = [ ./Cargo.lock.patch ];

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
    homepage = https://github.com/XAMPPRocky/tokei;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gebner lilyball ];
    platforms = platforms.all;
  };
}
