{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "jsonwatch";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TGW04P8t0mAXza7I7qp6QRXA/MDE3m1dlRC7bMf2dSk=";
  };

  cargoSha256 = "sha256-Gjb7v3kz11iOml3Ykxhy43KNxzaprgMbb5DpPNChLTc=";

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Like watch -d but for JSON";
    longDescription = ''
      jsonwatch is a command line utility with which you can track
      changes in JSON data delivered by a shell command or a web
      (HTTP/HTTPS) API. jsonwatch requests data from the designated
      source repeatedly at a set interval and displays the
      differences when the data changes.
    '';
    homepage = "https://github.com/dbohdan/jsonwatch";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
