{ lib
, rustPlatform
, fetchFromGitHub
, linux-doc
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "systeroid";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+OwixA1m0/17auVNJkBv+cVhYrYgLr6Gv4qr4rzd1Xk=";
  };

  postPatch = ''
    substituteInPlace systeroid-core/src/parsers.rs \
      --replace '"/usr/share/doc/kernel-doc-*/Documentation/*",' '"${linux-doc}/share/doc/linux-doc/*",'
  '';

  cargoSha256 = "sha256-FM0xX3adPmHBBJuLtTSOfAd71mBRVduMx/eqkJjw9Q0=";

  buildInputs = [
    xorg.libxcb
  ];

  # tries to access /sys/
  doCheck = false;

  meta = with lib; {
    description = "More powerful alternative to sysctl(8) with a terminal user interface";
    homepage = "https://github.com/orhun/systeroid";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
