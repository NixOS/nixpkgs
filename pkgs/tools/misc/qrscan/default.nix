{
  clang_15,
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "qrscan";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = "qrscan";
    rev = "v${version}";
    hash = "sha256-nAUZUE7NppsCAV8UyR8+OkikT4nJtnamsSVeyNz21EQ=";
  };

  nativeBuildInputs = [
    (rustPlatform.bindgenHook.overrideAttrs {
      libclang = clang_15.cc.lib;
    })
  ];

  cargoHash = "sha256-P40IwFRtEQp6BGRgmt1x3UXtAKtWaMjR3kqhYq+p7wQ=";

  checkFlags = [
    # requires filesystem write access
    "--skip=tests::test_export_files"
    "--skip=tests::test_scan_from_stdin"
    "--skip=tests::test_scan_jpeg_file"
    "--skip=tests::test_scan_no_content"
    "--skip=tests::test_scan_png_file"
  ];

  meta = with lib; {
    description = "Scan a QR code in the terminal using the system camera or a given image";
    mainProgram = "qrscan";
    homepage = "https://github.com/sayanarijit/qrscan";
    license = licenses.mit;
    broken = stdenv.isDarwin;
    maintainers = [ maintainers.sayanarijit ];
  };
}
