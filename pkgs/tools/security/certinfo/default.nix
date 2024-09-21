{ stdenv, lib, buildGoModule, fetchFromGitHub, libX11, darwin }:

buildGoModule rec {
  pname = "certinfo";
  version = "1.0.23";

  src = fetchFromGitHub {
    owner = "pete911";
    repo = "certinfo";
    rev = "v${version}";
    sha256 = "sha256-el7qL2d8z50S+0vyy8zH1W1uNix9PXmDGS5y8P9fIVA=";
  };

  # clipboard functionality not working on Darwin
  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);

  buildInputs = [ ]
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
