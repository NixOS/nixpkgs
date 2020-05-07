{ stdenv, buildGoPackage, fetchFromGitHub, installShellFiles }:

buildGoPackage rec {
  pname = "cloudfoundry-cli";
  version = "6.46.1";

  goPackagePath = "code.cloudfoundry.org/cli";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0dqrkimwhw016icgyf4cyipzy6vdz5jgickm33xxd9018dh3ibwq";
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
    installShellCompletion --bash "$src/ci/installers/completion/cf"
  '';

  meta = with stdenv.lib; {
    description = "The official command line client for Cloud Foundry";
    homepage = "https://github.com/cloudfoundry/cli";
    maintainers = with maintainers; [ ris ];
    license = licenses.asl20;
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
