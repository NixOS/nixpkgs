{ acl
, fetchFromGitHub
, lib
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "laurel";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "threathunters-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-IGmpNSHGlQGJn4cvcXXWbIOWqsXizzp1azfT41B4rm4=";
  };

  cargoHash = "sha256-jm1AWybDnpc1E4SWieQcsVwn8mxkJ5damMsXqg54LI8=";

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
