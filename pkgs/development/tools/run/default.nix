{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "run";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "TekWizely";
    repo = "run";
    rev = "v${version}";
    sha256 = "sha256-ClSB+v153Tj1cKLSmT9Z0IEyc+OABPeG519PzT03pX0=";
  };

  vendorSha256 = "sha256-4n8RRnDNu1Khv3V5eUB/eaFFJGVD/GdqMOywksc2LPw=";

  doCheck = false;

  meta = with lib; {
    description = "Easily manage and invoke small scripts and wrappers";
    homepage    = "https://github.com/TekWizely/run";
    license     = licenses.mit;
    maintainers = with maintainers; [ rawkode Br1ght0ne ];
    platforms   = platforms.unix;
  };
}
