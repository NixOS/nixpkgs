{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  libX11,
  darwin,
}:

buildGoModule rec {
  pname = "certinfo";
  version = "1.0.21";

  src = fetchFromGitHub {
    owner = "pete911";
    repo = "certinfo";
    rev = "v${version}";
    sha256 = "acAjX4M/egAhGVOeEKw5r2wteA/UsWf9fGR/HnhUr/w=";
  };

  # clipboard functionality not working on Darwin
  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);

  buildInputs =
    [ ]
    ++ lib.optionals stdenv.isLinux [ libX11 ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ];

  vendorHash = null;

  meta = with lib; {
    description = "Print x509 certificate info";
    mainProgram = "certinfo";
    homepage = "https://github.com/pete911/certinfo";
    license = licenses.mit;
    maintainers = with maintainers; [ jakuzure ];
  };
}
