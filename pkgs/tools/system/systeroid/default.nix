{ lib
, rustPlatform
, fetchFromGitHub
, linux-doc
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "systeroid";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xf81wyp5qg67r0vyqg0209pcabx70vvxx4nrg2y7qa0mhvf6p94";
  };

  postPatch = ''
    substituteInPlace systeroid-core/src/parsers.rs \
      --replace '"/usr/share/doc/kernel-doc-*/Documentation/*",' '"${linux-doc}/share/doc/linux-doc/*",'
  '';

  cargoSha256 = "sha256-D/sSeMR1Zg3OH1fdSVKdxdIcoP4OLp3T8mwQ28O8rfk=";

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
