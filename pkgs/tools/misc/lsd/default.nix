{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
, testVersion
, lsd
}:

rustPlatform.buildRustPackage rec {
  pname = "lsd";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "Peltoche";
    repo = pname;
    rev = version;
    sha256 = "sha256-4pa8yJjUTO5MUDuljfU9Vo2ZjbsIwWJsJj6VVNfN25A=";
  };

  cargoSha256 = "sha256-P0HJVp2ReJuLSZrArw/EAfLFDOZqswI0nD1SCHwegoE=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion $releaseDir/build/lsd-*/out/{_lsd,lsd.{bash,fish}}
  '';

  # Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  doCheck = false;

  passthru.tests.version = testVersion {
    package = lsd;
  };

  meta = with lib; {
    homepage = "https://github.com/Peltoche/lsd";
    description = "The next gen ls command";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne marsam zowoq SuperSandro2000 ];
  };
}
