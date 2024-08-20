{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, Security, zlib }:

rustPlatform.buildRustPackage rec {
  pname = "tokei";
  version = "13.0.0-alpha.1";

  src = fetchFromGitHub {
    owner = "XAMPPRocky";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oKgTBfwOAP4fJzgN8NBR0KcuVD0caa9Qf3dkCb0zUR8=";
  };

  cargoHash = "sha256-NE6hw6rgSDOsmSD6JpOfBLgGKGPfPmHjpMIsqLOkH7M=";

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv Security
  ];

  checkInputs = lib.optionals stdenv.isDarwin [ zlib ];

  # enable all output formats
  buildFeatures = [ "all" ];

  meta = with lib; {
    description = "Program that allows you to count your code, quickly";
    longDescription = ''
      Tokei is a program that displays statistics about your code. Tokei will show number of files, total lines within those files and code, comments, and blanks grouped by language.
    '';
    homepage = "https://github.com/XAMPPRocky/tokei";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gebner ];
    mainProgram = "tokei";
  };
}
