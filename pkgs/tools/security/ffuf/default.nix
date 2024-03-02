{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "ffuf";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "ffuf";
    repo = "ffuf";
    rev = "refs/tags/v${version}";
    hash = "sha256-+wcNqQHtB8yCLiJXMBxolCWsYZbBAsBGS1hs7j1lzUU=";
  };

  vendorHash = "sha256-SrC6Q7RKf+gwjJbxSZkWARw+kRtkwVv1UJshc/TkNdc=";

  patches = [
    # Fix CSV test, https://github.com/ffuf/ffuf/pull/731
    (fetchpatch {
      name = "fix-csv-test.patch";
      url = "https://github.com/ffuf/ffuf/commit/7f2aae005ad73988a1fa13c1c33dab71f4ae5bbd.patch";
      hash = "sha256-/v9shGICmsbFfEJe4qBkBHB9PVbBlrjY3uFmODxHu9M=";
    })
  ];

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Tool for web fuzzing";
    longDescription = ''
      FFUF, or “Fuzz Faster you Fool” is an open source web fuzzing tool,
      intended for discovering elements and content within web applications
      or web servers.
    '';
    homepage = "https://github.com/ffuf/ffuf";
    changelog = "https://github.com/ffuf/ffuf/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
