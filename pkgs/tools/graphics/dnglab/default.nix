{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "dnglab";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "dnglab";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GMpLvD6ueelBVBDxg33HqZ97gpXZ4sV2dGiOILPbaQA=";
  };

  cargoHash = "sha256-jIHYwIjhEbDW+c0R3dT1LZjmJrBDUTrB848hYAhDpWk=";

  postInstall = ''
    rm $out/bin/benchmark $out/bin/identify
  '';

  meta = with lib; {
    description = "Camera RAW to DNG file format converter";
    homepage = "https://github.com/dnglab/dnglab";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "dnglab";
  };
}
