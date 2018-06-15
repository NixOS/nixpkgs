{ stdenv, buildGoPackage, fetchFromGitHub, go }:

buildGoPackage rec {
  name = "cloudfoundry-cli-${version}";
  version = "6.36.1";

  goPackagePath = "code.cloudfoundry.org/cli";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "cli";
    rev = "v${version}";
    sha256 = "19inl7qs2acs59p3gnl5zdsxym0wp2rn05q0zfg7rwf5sjh68amp";
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
