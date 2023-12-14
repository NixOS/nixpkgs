{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fx";
  version = "31.0.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = pname;
    rev = version;
    hash = "sha256-AVaMViu+65xyYW3TzIigNXf5FfKb2v+TU/BMZqCX/Js=";
  };

  vendorHash = "sha256-kE6JotKP3YQ0B3HvyNU3fTvuwbnqTW8cwGVBYpiBvso=";

  meta = with lib; {
    description = "Terminal JSON viewer";
    homepage = "https://github.com/antonmedv/fx";
    changelog = "https://github.com/antonmedv/fx/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
