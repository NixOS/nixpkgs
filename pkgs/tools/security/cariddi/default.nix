{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cariddi";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cwkycydwndda11m1jszbxchpqabrgspj17y2aj3y3m2x446h27z";
  };

  vendorSha256 = "0rmiya517i9s4l9nxzwly5vq8cqhhpq66rc7y4sapyaihx20ai3r";

  meta = with lib; {
    description = "Crawler for URLs and endpoints";
    homepage = "https://github.com/edoardottt/cariddi";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
