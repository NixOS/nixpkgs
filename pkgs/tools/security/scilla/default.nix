{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "scilla";
  version = "20210118-${lib.strings.substring 0 7 rev}";
  rev = "74dd81492fef92b95765df1d0f629276a146a5a4";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    inherit rev;
    sha256 = "10qvaigfarljydfb9vx2fb9nk293j4g9w2h9mr8xw6adbvl0qr9q";
  };

  vendorSha256 = "04wqsl4269gc3r6l9srqhcq19zarnyyab8k1shj3w6lkfcc61z25";

  meta = with lib; {
    description = "Information gathering tool for DNS, ports and more";
    homepage = "https://github.com/edoardottt/scilla";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
