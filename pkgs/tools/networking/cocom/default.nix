{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "cocom";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "LamdaLamdaLamda";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sl4ivn95sr5pgw2z877gmhyfc4mk9xr457i5g2i4wqnf2jmy14j";
  };

  cargoSha256 = "04kj1yj6hhnis3ss0xs4zq8rl71rzn577g8i0wmapkjqzqwg37yb";

  buildInputs = lib.optional stdenv.isDarwin Security;

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "NTP client";
    homepage = "https://github.com/LamdaLamdaLamda/cocom";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "cocom";
  };
}
