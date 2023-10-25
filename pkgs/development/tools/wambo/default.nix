{ fetchCrate
, lib
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "wambo";
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-WZQgQmoFmsWLgPYRWonJmyKq9IIJ+a6J+O19XPppJG4=";
  };

  cargoHash = "sha256-ghUdhWW5gURWxj/OhbcKPNeLzeJvndqAxEZmwKBATUk=";

  meta = {
    description = "All-in-one tool to convert decimal/bin/oct/hex and interpret bits as integers";
    longDescription = ''
      wambo is a binary that can easily shows you a numeric value in all important numeral systems
      (bin, hex, dec) + interprets the input as both signed and unsigned values (from i8 to i64,
      including f32 and f64). It also easily calculates you mibibytes to bytes, kilobytes to gibibytes,
      and so on.
    '';
    homepage = "https://github.com/phip1611/wambo";
    changelog = "https://github.com/phip1611/wambo/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ phip1611 ];
  };
}
