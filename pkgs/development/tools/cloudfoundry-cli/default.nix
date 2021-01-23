{ lib, stdenv, buildGoPackage, fetchFromGitHub, fetchurl, installShellFiles }:

buildGoPackage rec {
  pname = "cloudfoundry-cli";
  version = "7.0.1";

  goPackagePath = "code.cloudfoundry.org/cli";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0jh4x7xlijp1naak5qyc256zkzlrczl6g4iz94s8wx2zj7np0q5l";
  };

  # upstream have helpfully moved the bash completion script to a separate
  # repo which receives no releases or even tags
  bashCompletionScript = fetchurl {
    url = "https://raw.githubusercontent.com/cloudfoundry/cli-ci/6087781a0e195465a35c79c8e968ae708c6f6351/ci/installers/completion/cf7";
    sha256 = "1vhg9jcgaxcvvb4pqnhkf27b3qivs4d3w232j0gbh9393m3qxrvy";
  };

  nativeBuildInputs = [ installShellFiles ];

  makeTarget = let hps = stdenv.hostPlatform.system; in
    if hps == "x86_64-darwin" then
      "out/cf-cli_osx"
    else if hps == "x86_64-linux" then
      "out/cf-cli_linux_x86-64"
    else if hps == "i686-linux" then
      "out/cf-cli_linux_i686"
    else
      throw "make target for this platform unknown";

  buildPhase = ''
    cd go/src/${goPackagePath}
    CF_BUILD_DATE="1970-01-01" make $makeTarget
    cp $makeTarget out/cf
  '';

  installPhase = ''
    install -Dm555 out/cf "$out/bin/cf"
    installShellCompletion --bash $bashCompletionScript
  '';

  meta = with lib; {
    description = "The official command line client for Cloud Foundry";
    homepage = "https://github.com/cloudfoundry/cli";
    maintainers = with maintainers; [ ris ];
    license = licenses.asl20;
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
