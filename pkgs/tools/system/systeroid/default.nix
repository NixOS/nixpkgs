{ lib
, rustPlatform
, fetchFromGitHub
, linux-doc
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "systeroid";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-V3b6jrxxgapiqtvcEeLRIB2S3CXDOi+sWm+cO0zOpkA=";
  };

  postPatch = ''
    substituteInPlace systeroid-core/src/parsers.rs \
      --replace '"/usr/share/doc/kernel-doc-*/Documentation/*",' '"${linux-doc}/share/doc/linux-doc/*",'
  '';

  cargoHash = "sha256-K2fWQ4X6/PypYyw2cDXl9bol16PvJHqnEcF5N3BEIdo=";

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
