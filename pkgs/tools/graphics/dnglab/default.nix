{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "dnglab";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "dnglab";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xiqUL35wY/nMHEiPMlmGOkfJENKBXrlElbDWZIw2600=";
  };

  cargoHash = "sha256-EUALrjSmDD/xqBdNlRhBk/67sNkwVOEs951Z980dwqc=";

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
