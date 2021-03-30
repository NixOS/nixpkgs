{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cosign";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zwb2q62ngb2zh1hasvq7r7pmrjlpgfhs5raibbhkxbk5kayvmii";
  };

  vendorSha256 = "0nwbjaps4z5fhiknbj9pybxb6kgwb1vf2qhy0mzpycprf04q6g0v";

  subPackages = [ "cmd/cosign" ];

  meta = with lib; {
    homepage = "https://github.com/sigstore/cosign";
    changelog = "https://github.com/sigstore/cosign/releases/tag/v${version}";
    description = "Container Signing CLI with support for ephemeral keys and Sigstore signing";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse ];
  };
}
