{ acl
, fetchFromGitHub
, lib
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "laurel";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "threathunters-io";
    repo = "laurel";
    rev = "refs/tags/v${version}";
    hash = "sha256-dGgBcugIQ3ZPnqyTw6wRMN2PZLm6GqobeFZ1/uzMKbs=";
  };

  cargoHash = "sha256-8JNLssWTCfwrfQ/jg/rj7BUo9bCNCsM2RDwPI7cacRw=";

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
