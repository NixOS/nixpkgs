{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "tokei";
  version = "12.1.2";

  src = fetchFromGitHub {
    owner = "XAMPPRocky";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jqDsxUAMD/MCCI0hamkGuCYa8rEXNZIR8S+84S8FbgI=";
  };

  cargoSha256 = "sha256-U7Bode8qwDsNf4FVppfEHA9uiOFz74CtKgXG6xyYlT8=";

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv Security
  ];

  # enable all output formats
  cargoBuildFlags = [ "--features" "all" ];

  meta = with lib; {
    description = "A program that allows you to count your code, quickly";
    longDescription = ''
      Tokei is a program that displays statistics about your code. Tokei will show number of files, total lines within those files and code, comments, and blanks grouped by language.
    '';
    homepage = "https://github.com/XAMPPRocky/tokei";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gebner lilyball ];
  };
}
