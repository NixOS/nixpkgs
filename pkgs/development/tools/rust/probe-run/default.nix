{ lib, stdenv, rustPlatform, fetchCrate, pkg-config, libusb1
, libiconv, AppKit, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "probe-run";
  version = "0.3.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-xVxigZET2/7xr+bb3r80F3y0yaNV1JeGeJ2EF0GWa1A=";
  };

  cargoSha256 = "sha256-MK3F3Kt80Xdbbm68Jv1uh78nAj1LzJ90H54NYdn+Oms=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ]
    ++ lib.optionals stdenv.isDarwin [ libiconv AppKit IOKit ];

  meta = with lib; {
    description = "Run embedded programs just like native ones";
    homepage = "https://github.com/knurling-rs/probe-run";
    changelog = "https://github.com/knurling-rs/probe-run/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ hoverbear newam ];
  };
}
