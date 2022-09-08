{ lib
, rustPlatform
, fetchFromGitHub
, linux-doc
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "systeroid";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Xkpa5W+smNMrcWXylOy0fU1wI7jBF9Bw16pzI5IDFI4=";
  };

  postPatch = ''
    substituteInPlace systeroid-core/src/parsers.rs \
      --replace '"/usr/share/doc/kernel-doc-*/Documentation/*",' '"${linux-doc}/share/doc/linux-doc/*",'
  '';

  cargoSha256 = "sha256-A9yd/Z94B6beWyiiRl7rJQOj7YMNFHkjhtu5MHG8/XA=";

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
