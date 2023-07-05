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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vV7P2e6kv6CCHbI5Roz9WElntl3t/5ySXUw3XXEXMv4=";
  };

  cargoHash = "sha256-oAkZHx33YrwRUUIoooqpy72QCq0ZkAgBZ8W8XDe2fNE=";

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
