{ lib
, rustPlatform
, fetchFromGitHub
, rust-cbindgen
}:

rustPlatform.buildRustPackage rec {
  pname = "orz";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "richox";
    repo = "orz";
    rev = "v${version}";
    hash = "sha256-Yro+iXlg18Pj/AkU4IjvgA88xctK65yStfTilz+IRs0=";
  };

  cargoHash = "sha256-aUsRbIajBP6esjW7Wj7mqIkbYUCbZ2GgxjRXMPTnHYg=";

  outputs = [ "out" "dev" "lib" ];

  nativeBuildInputs = [
    rust-cbindgen
  ];

  postInstall = ''
    cbindgen -o $dev/include/orz.h

    mkdir -p $lib
    mv $out/lib "$lib"
  '';

  meta = with lib; {
    description = "A high performance, general purpose data compressor written in rust";
    homepage = "https://github.com/richox/orz";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "orz";
  };
}
