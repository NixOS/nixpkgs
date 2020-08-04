{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "kepubify";
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "pgaskin";
    repo = pname;
    rev = "v${version}";
    sha256 = "0d71d1ra7lk4ayypq3fcigd9lpb2dafa8ci14h0g7rivm4lz8l1j";
  };

  vendorSha256 = "0jzx5midawvzims9ghh8fbslvwcdczvlpf0k6a9q0bdf4wlp2z5n";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  excludedPackages = [ "kobotest" ];

  doCheck = true;

  meta = with lib; {
    description = "EPUB to KEPUB converter";
    homepage = "https://pgaskin.net/kepubify";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
