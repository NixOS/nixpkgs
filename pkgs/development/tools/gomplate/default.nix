{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomplate";
  version = "3.8.0";
  owner = "hairyhenderson";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit owner rev;
    repo = pname;
    sha256 = "058shbrhpd8ghdj5qa6n7mf1bh8qvpmiv3yjj39jys359zhin06n";
  };

  vendorSha256 = "0wqz3anxlzb0ds6xmpnaxq5rjgcmzkzrdqhnkfkjq32b7mj9mks3";

  # some tests require network access
  postPatch = ''
    rm net/net_test.go
  '';

  buildFlagsArray = [
    "-ldflags="
    "-s"
    "-w"
    "-X github.com/${owner}/${pname}/v3/version.Version=${rev}"
  ];

  meta = with stdenv.lib; {
    description = "A flexible commandline tool for template rendering";
    homepage = "https://gomplate.ca/";
    maintainers = with maintainers; [ ris jlesquembre ];
    license = licenses.mit;
  };
}
