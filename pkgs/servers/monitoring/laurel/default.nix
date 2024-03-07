{ acl
, fetchFromGitHub
, fetchpatch
, lib
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "laurel";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "threathunters-io";
    repo = "laurel";
    rev = "refs/tags/v${version}";
    hash = "sha256-lWVrp0ytomrQBSDuQCMFJpSuAuwjSYPwoE4yh/WO2ls=";
  };

  cargoHash = "sha256-GY7vpst+Epsy/x/ths6pwtGQgM6Bx0KI+NsCMFCBujE=";

  cargoPatches = [
    # Upstream forgot to bump the Cargo.lock before tagging the release.
    # This patch is the first commit immediately after the tag fixing this mistake.
    # Needs to be removed next release.
    (fetchpatch {
      name = "Cargo-lock-version-bump.patch";
      url = "https://github.com/threathunters-io/laurel/commit/f38393d1098e8f75394f83ad3da5c1160fb96652.patch";
      hash = "sha256-x+7p21X38KYqLclFtGnLO5nOHz819+XTaSPMvDbSo/I=";
    })
  ];

  nativeBuildInputs = [ rustPlatform.bindgenHook ];
  buildInputs = [ acl ];

  meta = with lib; {
    description = "Transform Linux Audit logs for SIEM usage";
    homepage = "https://github.com/threathunters-io/laurel";
    changelog = "https://github.com/threathunters-io/laurel/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ emilylange ];
    platforms = platforms.linux;
  };
}
