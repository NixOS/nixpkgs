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
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jg2rMiFXtN3oLru1gTaTyIo5eBEI23paKJiDV6KZZE4=";
  };

  cargoHash = "sha256-9Gri/EBaUiCpFBL0f132JDD4Zl5v40e8JmlRvm019S4=";

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
