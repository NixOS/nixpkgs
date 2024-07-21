{ lib
, buildGoModule
, fetchFromSourcehut
, libxkbcommon
, pkg-config
}:

buildGoModule rec {
  pname = "dotool";
  version = "1.3";

  src = fetchFromSourcehut {
    owner = "~geb";
    repo = "dotool";
    rev = version;
    hash = "sha256-z0fQ+qenHjtoriYSD2sOjEvfLVtZcMJbvnjKZFRSsMA=";
  };

  vendorHash = "sha256-v0uoG9mNaemzhQAiG85RequGjkSllPd4UK2SrLjfm7A=";

  # uses nix store path for the dotool binary
  # also replaces /bin/echo with echo
  patches = [ ./fix-paths.patch ];

  postPatch = ''
    substituteInPlace ./dotoold --replace "@dotool@" "$out/bin/dotool"
  '';

  buildInputs = [ libxkbcommon ];
  nativeBuildInputs = [ pkg-config ];

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  postInstall = ''
    mkdir -p $out/bin
    cp ./dotoold ./dotoolc $out/bin
  '';

  meta = with lib; {
    description = "Command to simulate input anywhere";
    homepage = "https://git.sr.ht/~geb/dotool";
    changelog = "https://git.sr.ht/~geb/dotool/tree/${version}/item/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
  };
}
