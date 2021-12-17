{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.8.8";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-7VTx52V70i4N7ZmprX9cLrYu7xCSmb+m+Yaphs94c4w";
  };

  cargoHash = "sha256-is9O0fQacE+j9gyZDIWgo3AXMs4ZGUVE5EKUO4ntjq8";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
