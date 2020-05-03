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

  modSha256 = "0v9lg5kq3776b2s4kgyi19jy8shjqrr0f5ljrchsj1k7867sxiw7";

  meta = {
    description = "Tool to get list available Go packages.";
    homepage = "https://github.com/uudashr/gopkgs";
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.mit;
  };
}
