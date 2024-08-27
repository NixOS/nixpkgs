{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "dnglab";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "dnglab";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EJ0uWc3pp7ixRxDIdTIVVaT2ph3P2IvuK+ecBSB5HYw=";
  };

  cargoHash = "sha256-6qJFNfgWh3i1CpuM/QdLksVAFz4XIV8uT5oz5BZ3U30=";

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
