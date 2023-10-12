{ acl
, fetchFromGitHub
, lib
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "laurel";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "threathunters-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4SOnBIi45g2hYo+nFLI5soS+qRPzjkSYwmyMfVZCyVo=";
  };

  cargoHash = "sha256-yrk3frsR8AQGDVFgP2fCIWmhw+dTZwvga1hF0IAwzjQ=";

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
