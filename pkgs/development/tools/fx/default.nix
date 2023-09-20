{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "fx";
  version = "30.0.2";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = pname;
    rev = version;
    hash = "sha256-dpIkWgABATDyG3pCdeDKVar53eBHFP3f9XNKkTrr96c=";
  };

  patches = [
    # fix failing test
    (fetchpatch {
      name = "fix-dig-test.patch";
      url = "https://github.com/antonmedv/fx/commit/adf3775828157d903e3f32ab4023fe750fa85e68.patch";
      hash = "sha256-/6UfI0IW/+ZbgXi3W6BRTfVPko7V4s/NnaunvLDcw2A=";
    })
  ];

  vendorHash = "sha256-FyV3oaI4MKl0LKJf23XIeUmvFsa1DvQw2pq5Heza3Ws=";

  meta = with lib; {
    description = "Terminal JSON viewer";
    homepage = "https://github.com/antonmedv/fx";
    changelog = "https://github.com/antonmedv/fx/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
