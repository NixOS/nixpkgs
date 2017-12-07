{ stdenv, buildGoPackage, fetchFromGitHub, go }:

buildGoPackage rec {
  name = "cloudfoundry-cli-${version}";
  version = "6.32.0";

  goPackagePath = "code.cloudfoundry.org/cli";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cloudfoundry-attic";
    repo = "cli-with-i18n";
    sha256 = "16r8zvahn4b98krmyb8zq9370i6572dhz88bfxb3fnddcv6zy1ng";
  };

  outputs = [ "out" ];

  buildFlagsArray = ''
    -ldflags= -X ${goPackagePath}/version.binaryVersion=${version}
  '';

  installPhase = ''
    install -Dm555 go/bin/cli "$out/bin/cf"
    remove-references-to -t ${go} "$out/bin/cf"
    install -Dm444 -t "$out/share/bash-completion/completions/" "$src/ci/installers/completion/cf"
  '';

  meta = with stdenv.lib; {
    description = "The official command line client for Cloud Foundry";
    homepage = https://github.com/cloudfoundry/cli;
    maintainers = with maintainers; [ ris ];
    license = licenses.asl20;
  };
}
