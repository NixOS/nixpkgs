{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "dnglab";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "dnglab";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jkOkkcMFK1RLY8Hn/bMMuMZtyGwnwGdm0os8QKhcWqo=";
  };

  cargoSha256 = "sha256-qwhOJxFYRJC51dKB1pi/WVJs7H955jM6KmKbxsAScDI=";

  postInstall = ''
    rm $out/bin/benchmark $out/bin/identify
  '';

  meta = with lib; {
    description = "Camera RAW to DNG file format converter";
    homepage = "https://github.com/dnglab/dnglab";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dit7ya ];
  };
}
