{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, pandoc
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "fend";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9qvIxKg/fj08wYY2fK5J1nWzojStUb9ArXwvA/cTOcQ=";
  };

  cargoHash = "sha256-kVnA8w2YVg6+h1V1O4cvciuB7GM4/LULFsGrzy8xUMQ=";

  nativeBuildInputs = [ pandoc installShellFiles ];
  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  postBuild = ''
    patchShebangs --build ./documentation/build.sh
    ./documentation/build.sh
  '';

  preFixup = ''
    installManPage documentation/fend.1
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    [[ "$($out/bin/fend "1 km to m")" = "1000 m" ]]
  '';

  meta = with lib; {
    description = "Arbitrary-precision unit-aware calculator";
    homepage = "https://github.com/printfn/fend";
    license = licenses.mit;
    maintainers = with maintainers; [ djanatyn ];
  };
}
