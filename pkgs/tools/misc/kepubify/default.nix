{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "kepubify";
  version = "3.1.5";

  src = fetchFromGitHub {
    owner = "pgaskin";
    repo = pname;
    rev = "v${version}";
    sha256 = "047pwn7yzm456cs175vgqk2pd6i3iqn8zxp38px3ah15vym2yjnp";
  };

  vendorSha256 = "0jzx5midawvzims9ghh8fbslvwcdczvlpf0k6a9q0bdf4wlp2z5n";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  excludedPackages = [ "kobotest" ];

  meta = with lib; {
    description = "EPUB to KEPUB converter";
    homepage = "https://pgaskin.net/kepubify";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
