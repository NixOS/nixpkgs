{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "credhub-cli";
  version = "2.9.16";

  src = fetchFromGitHub {
    owner = "cloudfoundry-incubator";
    repo = "credhub-cli";
    rev = version;
    sha256 = "sha256-NfGS5kUfmv1djYMqB1HrNFgM2cBfW4EZHrkxhwmBWKQ=";
  };

  # these tests require network access that we're not going to give them
  postPatch = ''
    rm commands/api_test.go
    rm commands/socks5_test.go
  '';
  __darwinAllowLocalNetworking = true;

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X code.cloudfoundry.org/credhub-cli/version.Version=${version}"
  ];

  postInstall = ''
    ln -s $out/bin/credhub-cli $out/bin/credhub
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Provides a command line interface to interact with CredHub servers";
    homepage = "https://github.com/cloudfoundry-incubator/credhub-cli";
    maintainers = with maintainers; [ ris ];
    license = licenses.asl20;
  };
}
