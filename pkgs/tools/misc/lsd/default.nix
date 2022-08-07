{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
, pandoc
, testers
, lsd
}:

rustPlatform.buildRustPackage rec {
  pname = "lsd";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "Peltoche";
    repo = pname;
    rev = version;
    sha256 = "sha256-YeSEaamtIjip2nLBw/1/RSkr6ZL0p1GG2pHU14Ry6XU=";
  };

  cargoSha256 = "sha256-JsPGw5hjNy+yTZiSBeF05o9Zl6pYXxEI4kIDLY6Q54Q=";

  nativeBuildInputs = [ installShellFiles pandoc ];
  postInstall = ''
    pandoc --standalone --to man doc/lsd.md -o lsd.1
    installManPage lsd.1

    installShellCompletion $releaseDir/build/lsd-*/out/{_lsd,lsd.{bash,fish}}
  '';

  # Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = lsd;
  };

  meta = with lib; {
    homepage = "https://github.com/Peltoche/lsd";
    description = "The next gen ls command";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne marsam zowoq SuperSandro2000 ];
  };
}
