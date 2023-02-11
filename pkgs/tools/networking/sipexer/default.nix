{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sipexer";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "miconda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cM40hxHMBH0wT1prSRipAZscSBxkZX7riwCrnLQUT0k=";
  };

  vendorSha256 = "sha256-q2uNqKZc6Zye7YimPDrg40o68Fo4ux4fygjVjJdhqQU=";

  meta = with lib; {
    description = "Modern and flexible SIP CLI tool";
    homepage = "https://github.com/miconda/sipexer";
    changelog = "https://github.com/miconda/sipexer/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ astro ];
  };
}
