{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "asciinema-scenario";
  version = "0.1.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ubiVpKFU81Ot9V9oMexWSiUXHepoJ6nXtrWVAFhgcYw=";
  };

  cargoSha256 = "0ii646m6dxaaypl84p1vjpf7mnnj8jrssr6d7410mwfvpq9821al";

  meta = with lib; {
    description = "Create asciinema videos from a text file";
    homepage = "https://github.com/garbas/asciinema-scenario/";
    maintainers = with maintainers; [ garbas ];
    license = with licenses; [ mit ];
  };
}
