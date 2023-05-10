{ acl
, fetchFromGitHub
, lib
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "laurel";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "threathunters-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MT3Zcuztb2QUwWR3HFViJQtygI0oIUE3TlMu+vWzbMI=";
  };

  cargoHash = "sha256-hX2nSBgXctAHGqvP/ZmMjGJf7C/wPJ/gL+gV7uI8gco=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];
  buildInputs = [ acl ];

  meta = with lib; {
    description = "Transform Linux Audit logs for SIEM usage";
    homepage = "https://github.com/threathunters-io/laurel";
    changelog = "https://github.com/threathunters-io/laurel/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ indeednotjames ];
    platforms = platforms.linux;
  };
}
