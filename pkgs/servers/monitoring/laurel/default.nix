{ acl
, fetchFromGitHub
, lib
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "laurel";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "threathunters-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-O1EdIEgg+QfOnnhcTpI1nwYjdLOWcdt90SQegn68AJI=";
  };

  cargoHash = "sha256-wseysbjMkjPgKk7X9PpBck/IuafIFXfbRy+fPfR1CEY=";

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
