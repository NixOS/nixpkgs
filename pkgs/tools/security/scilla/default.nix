{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "scilla";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-gZuNXQaxHJYLsEaOpNYo7ybg3f0GhkpiaLrex5lkDu4=";
  };

  vendorHash = "sha256-bVGmleuOJzi/Sz7MJlnQuJsDgRWuwieLUx8hcyKkWXI=";

  checkFlags = [
    # requires network access
    "-skip=TestIPToHostname"
  ];

  meta = with lib; {
    description = "Information gathering tool for DNS, ports and more";
    homepage = "https://github.com/edoardottt/scilla";
    changelog = "https://github.com/edoardottt/scilla/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
