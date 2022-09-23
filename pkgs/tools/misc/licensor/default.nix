{ lib
, fetchFromGitHub
, fetchpatch
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "licensor";
  version = "unstable-2021-02-03";

  src = fetchFromGitHub {
    owner = "raftario";
    repo = pname;
    rev = "1897882a708ec6ed65a9569ae0e07d6ea576c652";
    sha256 = "0x0lkfrj7jka0p6nx6i9syz0bnzya5z9np9cw09zm1c9njv9mm32";
  };

  cargoSha256 = "1h66d1brx441bg7vzbqdish4avgmc6h7rrkw2qf1siwmplwqqhw0";

  patches = [
    # Support for 2022, https://github.com/raftario/licensor/pull/68
    (fetchpatch {
      name = "support-for-2022.patch";
      url = "https://github.com/raftario/licensor/commit/6b2f248e5ad9e454fe30d71397691e47ac69b19e.patch";
      sha256 = "sha256-kXiY5s2kuU+ibV3RpBoy7y3cmJU+gECBTsmRXWBOTP8=";
    })
  ];

  meta = with lib; {
    description = "Write licenses to stdout";
    homepage = "https://github.com/raftario/licensor";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "licensor";
  };
}
