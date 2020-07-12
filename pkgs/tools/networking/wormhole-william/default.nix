{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wormhole-william";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "psanford";
    repo = "wormhole-william";
    rev = "v${version}";
    sha256 = "1v6kw10gqhyd1adj0wwrr5bmpjqbshdnywsrjpqgg9bl61m5j3wr";
  };

  vendorSha256 = "1niky252gcxai6vz0cx7pvflg530bc1lmcd2wm2hqg6446r1yxsq";

  meta = with stdenv.lib; {
    homepage = "https://github.com/psanford/wormhole-william";
    description = "End-to-end encrypted file transfers";
    changelog = "https://github.com/psanford/wormhole-william/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ psanford ];
  };
}
