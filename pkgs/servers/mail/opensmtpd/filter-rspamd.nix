{ lib
, buildGoModule
, fetchFromGitHub
,  nixosTests
}:

buildGoModule rec {
  pname = "opensmtpd-filter-rspamd";
<<<<<<< HEAD
  version = "0.1.8";
=======
  version = "0.1.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "poolpOrg";
    repo = "filter-rspamd";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Ud1irvEyYr9QDsm2PsnWoWkXoDH0WWeH73k/IbLrVf4=";
  };

  vendorHash = "sha256-sNF2c+22FMvKoROkA/3KtSnRdJh4YZLaIx35HD896HI=";
=======
    sha256 = "pcHj4utpf/AIUv8/7mE8BLbE8LYkzNKfc4T4hIHgGeI=";
  };

  vendorSha256 = "sNF2c+22FMvKoROkA/3KtSnRdJh4YZLaIx35HD896HI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.tests = {
    opensmtpd-rspamd-integration = nixosTests.opensmtpd-rspamd;
  };

  meta = with lib; {
    description = "OpenSMTPD filter integration for the Rspamd daemon";
    homepage = "https://github.com/poolpOrg/filter-rspamd";
    license = licenses.isc;
    maintainers = with maintainers; [ Flakebi ];
    mainProgram = "filter-rspamd";
  };
}
