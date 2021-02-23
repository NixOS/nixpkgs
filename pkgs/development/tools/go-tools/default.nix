{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-tools";
  version = "2020.2.2";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = version;
    sha256 = "1vk9c4hsv8i3zhkyrsd0cb5mscxl35ws5bykpp5h6g366rpl0dy1";
  };

  vendorSha256 = "081p008sb3lkc8j6sa6n42qi04za4a631kihrd4ca6aigwkgl3ak";

  doCheck = false;

  meta = with lib; {
    description = "A collection of tools and libraries for working with Go code, including linters and static analysis";
    homepage = "https://staticcheck.io";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs kalbasit ];
  };
}
