{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "lsd";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "Peltoche";
    repo = pname;
    rev = version;
    sha256 = "sha256-r/Rllu+tgKqz+vkxA8BSN+3V0lUUd6dEATfickQp4+s=";
  };

  cargoSha256 = "sha256-O8P29eYlHgmmAADZ/DgTBmj0ZOa+4u/Oee+TMF+/4Ro=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion $releaseDir/build/lsd-*/out/{_lsd,lsd.{bash,fish}}
  '';

  # Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    testFile=$(mktemp /tmp/lsd-test.XXXX)
    echo 'abc' > $testFile
    $out/bin/lsd --classic --blocks "size,name" -l $testFile | grep "4 B $testFile"
    $out/bin/lsd --version | grep "${version}"
    rm $testFile

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/Peltoche/lsd";
    description = "The next gen ls command";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne marsam zowoq SuperSandro2000 ];
  };
}
