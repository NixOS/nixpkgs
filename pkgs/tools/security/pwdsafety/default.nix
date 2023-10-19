{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pwdsafety";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ryMLiehJVZhQ3ZQf4/g7ILeJri78A6z5jfell0pD9E8=";
  };

  vendorHash = "sha256-b+tWTQUyYDzY2O28hwy5vI6b6S889TCiVh7hQhw/KAc=";

  meta = with lib; {
    description = "Command line tool checking password safety";
    homepage = "https://github.com/edoardottt/pwdsafety";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
