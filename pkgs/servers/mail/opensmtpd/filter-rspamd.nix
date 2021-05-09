{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "opensmtpd-filter-rspamd";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "poolpOrg";
    repo = "filter-rspamd";
    rev = "v${version}";
    sha256 = "1qhrw20q9y44ffgx5k14nvqc9dh47ihywgzza84g0zv9xgif7hd5";
  };

  vendorSha256 = "0wp87lziry8x4gd94qbqk1sd2admrbyh790kl75cn55nxmrpdldh";

  meta = with lib; {
    homepage = "https://github.com/poolpOrg/filter-rspamd";
    description = "OpenSMTPD filter integration for the Rspamd daemon";
    license = licenses.isc;
  };
}
