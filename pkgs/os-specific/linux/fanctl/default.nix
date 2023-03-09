{ lib, fetchFromGitLab, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "0.6.4";
  pname = "fanctl";

  src = fetchFromGitLab {
    owner = "mcoffin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XmawybmqRJ9Lj6ii8TZBFwqdQZVp0pOLN4xiSLkU/bw=";
  };

  cargoSha256 = "sha256-tj00DXQEqC/8+3uzTMWcph+1fNTTVZLSJbV/5lLFkFs=";

  meta = with lib; {
    description = "Replacement for fancontrol with more fine-grained control interface in its config file";
    homepage = "https://gitlab.com/mcoffin/fanctl";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ icewind1991 ];
    platforms = platforms.linux;
  };
}
