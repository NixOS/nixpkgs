{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "dnglab";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "dnglab";
    repo = "dnglab";
    rev = "v${version}";
    # darwin/linux hash mismatch
    postFetch = ''
      rm -rf "$out"/rawler/data/testdata/cameras/Canon/{"EOS REBEL T7i","EOS Rebel T7i"}
    '';
    hash = "sha256-k0tKNtVDzE5vVi/953aEQihh+5BsVneqauTr9WRFFrY=";
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
