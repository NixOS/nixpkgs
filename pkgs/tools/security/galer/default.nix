{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "galer";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "dwisiswant0";
    repo = pname;
    rev = "v${version}";
    sha256 = "1923071rk078mqk5mig45kcrr58ni02rby3r298myld7j9gfnylb";
  };

  vendorSha256 = "0p5b6cp4ccvcjiy3g9brcwb08wxjbrpsza525fmx38wyyi0n0wns";

  meta = with lib; {
    description = "Tool to fetch URLs from HTML attributes";
    homepage = "https://github.com/dwisiswant0/galer";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
