{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "step-cli";
  version = "0.15.3-22-g3ddc5aa";

  # 0.15.3 isn't enough, because we need https://github.com/smallstep/cli/pull/394
  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "cli";
    rev = "3ddc5aaafccb23ba9a20abfa70109a2923f298e3";
    sha256 = "1kd04hi764xa3f9p6aw6k9f6wa4y6xsmzby5jxvvkhim4w78brw0";
  };

  preCheck = ''
    # Tries to connect to smallstep.com
    rm command/certificate/remote_test.go
  '';
  vendorSha256 = "04hckq78g1p04b2q0rq4xw6d880hqhkabbx1pc3pf8r1m6jxwz10";

  meta = with lib; {
    description = "A zero trust swiss army knife for working with X509, OAuth, JWT, OATH OTP, etc";
    homepage = "https://smallstep.com/cli/";
    license = licenses.asl20;
    maintainers = with maintainers; [ xfix ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
