{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  Security,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "tokei";
  version = "12.1.2";

  src = fetchFromGitHub {
    owner = "XAMPPRocky";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jqDsxUAMD/MCCI0hamkGuCYa8rEXNZIR8S+84S8FbgI=";
  };

  cargoHash = "sha256-U7Bode8qwDsNf4FVppfEHA9uiOFz74CtKgXG6xyYlT8=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    Security
  ];

  checkInputs = lib.optionals stdenv.hostPlatform.isDarwin [ zlib ];

  # enable all output formats
  buildFeatures = [ "all" ];

  meta = with lib; {
    description = "Program that allows you to count your code, quickly";
    longDescription = ''
      Tokei is a program that displays statistics about your code. Tokei will show number of files, total lines within those files and code, comments, and blanks grouped by language.
    '';
    homepage = "https://github.com/XAMPPRocky/tokei";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ gebner ];
    mainProgram = "tokei";
  };
}
