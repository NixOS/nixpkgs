{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "changie";
  version = "1.9.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "miniscruff";
    repo = pname;
    sha256 = "sha256-3AGz84z0YmDiLxlbDO0f9ny75hyLB4fnYQSICElJVK4=";
  };

  vendorSha256 = "sha256-9Cpyemq/f62rVMvGwOtgDGd9XllvICXL2dqNwUoFQmg=";

  meta = with lib; {
    homepage = "https://changie.dev";
    description = "Automated changelog tool for preparing releases with lots of customization options";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

