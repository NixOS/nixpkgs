{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "credhub-cli";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "cloudfoundry-incubator";
    repo = "credhub-cli";
    rev = version;
    sha256 = "1j0i0b79ph2i52cj0qln8wvp6gwhl73akkn026h27vvmlw9sndc2";
  };

  # these tests require network access that we're not going to give them
  postPatch = ''
    rm commands/api_test.go
    rm commands/socks5_test.go
  '';
  __darwinAllowLocalNetworking = true;

  vendorSha256 = null;

  buildFlagsArray = [
    "-ldflags="
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

  meta = with stdenv.lib; {
    description = "Provides a command line interface to interact with CredHub servers";
    homepage = "https://github.com/cloudfoundry-incubator/credhub-cli";
    maintainers = with maintainers; [ ris ];
    license = licenses.asl20;
  };
}
