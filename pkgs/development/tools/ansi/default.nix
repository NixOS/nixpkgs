{ fetchCrate, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ansi-escape-sequences-cli";
  version = "0.1.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-KGPlNXkF16VdoOb3tg3nsQRdtgU83z7ibPy965bvvDk=";
  };

  cargoSha256 = "sha256-Q46VKBrOsjqUeSruuK/Bur2L69JAGr3c+ianfPlfzi0=";

  meta = with lib; {
    description = "Quickly get ANSI escape sequences";
    longDescription = ''
      CLI utility called "ansi" to quickly get ANSI escape sequences. Supports
      the colors and styles, such as bold or italic.";
    '';
    homepage = "https://github.com/phip1611/ansi-escape-sequences-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ phip1611 ];
    mainProgram = "ansi";
  };
}
