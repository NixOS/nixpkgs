{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ffuf";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dqABifXA104NCPdrWhB79cZQloJrqwJ45rlh+M/lRrs=";
  };

  vendorSha256 = "sha256-szT08rIozAuliOmge5RFX4NeVrJ2pCVyfotrHuvc0UU=";

  meta = with lib; {
    description = "Fast web fuzzer written in Go";
    longDescription = ''
      FFUF, or “Fuzz Faster you Fool” is an open source web fuzzing tool,
      intended for discovering elements and content within web applications
      or web servers.
    '';
    homepage = "https://github.com/ffuf/ffuf";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
