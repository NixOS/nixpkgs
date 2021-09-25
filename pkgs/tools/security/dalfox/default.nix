{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dalfox";
  version = "2.4.9";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "v${version}";
    sha256 = "1g0bafg3lgsqy8mjyzvvy9l1wp1rxqwpba3dkx6xisjkpbycxql8";
  };

  vendorSha256 = "1mw58zbihw2fzbpqwydfrrkcwqjkjqdzp37m4dijhx1pbzkv9gzl";

  meta = with lib; {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
