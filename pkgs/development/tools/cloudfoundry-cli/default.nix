{ stdenv, buildGoPackage, fetchFromGitHub, go }:

buildGoPackage rec {
  name = "cloudfoundry-cli-${version}";
  version = "6.37.0";

  goPackagePath = "code.cloudfoundry.org/cli";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "cli";
    rev = "v${version}";
    sha256 = "1v4f1fyydpzkfir46g4ppbf3zmk3ym6kxswpkdjls8h3dbb2fbnv";
  };

  outputs = [ "out" ];

  buildPhase = ''
    cd go/src/${goPackagePath}
    CF_BUILD_DATE="1970-01-01" make build
  '';

  installPhase = ''
    install -Dm555 out/cf "$out/bin/cf"
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
