{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "oneshot";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "raphaelreyna";
    repo = "oneshot";
    rev = "v${version}";
    sha256 = "sha256-LxLMETZzoeu7qEHpUFmo/h+7sdly+R5ZWsNhyttcbpA=";
  };

  vendorSha256 = "sha256-rL/NWIIggvngTrdTDm1g1uH3vC55JF3cWllPc6Yb5jc=";

  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "A first-come-first-serve single-fire HTTP server";
    homepage = "https://github.com/raphaelreyna/oneshot";
    license = licenses.mit;
    maintainers = with maintainers; [ edibopp ];
  };
}
