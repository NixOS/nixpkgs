{ acl
, fetchFromGitHub
, lib
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "laurel";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "threathunters-io";
    repo = "laurel";
    rev = "refs/tags/v${version}";
    hash = "sha256-1V5VonSH631bS5sIYkHC3lk4yumDCJ+LZHE00Kbx+J8=";
  };

  cargoHash = "sha256-GhgGMETOOPjG6ANwwavI5lhMmByq73KDHvcO5pnADHE=";

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
