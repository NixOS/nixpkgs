{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopkgs";
  version = "2.1.2";

  goPackagePath = "github.com/uudashr/gopkgs";

  subPackages = [ "cmd/gopkgs" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "uudashr";
    repo = "gopkgs";
    sha256 = "1jak1bg6k5iasscw68ra875k59k3iqhka2ykabsd427k1j3mypln";
  };

  vendorSha256 = "1pwsc488ldw039by8nqpni801zry7dnf0rx4hhd73xpv2w7s8n2r";

  meta = {
    description = "Tool to get list available Go packages.";
    homepage = "https://github.com/uudashr/gopkgs";
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.mit;
  };
}
