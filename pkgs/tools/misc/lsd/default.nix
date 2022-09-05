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
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "Peltoche";
    repo = pname;
    rev = version;
    sha256 = "sha256-E0STOvHeKC5uJ4l3+UU7L1gK9oKL/EChM7yVWCPqxLg=";
  };

  cargoSha256 = "sha256-jO/3BGZIx7XibaAqd+vO1mwku3BG91/vkwpHvrUYV+Y=";

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
