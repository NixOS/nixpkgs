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
    hash = "sha256-i3rrXpKnUV9REnn4lQWIFpWc2SzkxVomruiAmcMBQ6Q=";
  };

  vendorHash = "sha256-2nJgQfSeo9GrK6Kor29esnMEFmd5pTd8lGwzRi4zq1w=";

  meta = with lib; {
    description = "Tool to fetch URLs from HTML attributes";
    mainProgram = "galer";
    homepage = "https://github.com/dwisiswant0/galer";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
