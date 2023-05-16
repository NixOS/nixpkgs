{ acl
, fetchFromGitHub
, lib
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "laurel";
<<<<<<< HEAD
  version = "0.5.3";
=======
  version = "0.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "threathunters-io";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-4SOnBIi45g2hYo+nFLI5soS+qRPzjkSYwmyMfVZCyVo=";
  };

  cargoHash = "sha256-yrk3frsR8AQGDVFgP2fCIWmhw+dTZwvga1hF0IAwzjQ=";
=======
    hash = "sha256-MT3Zcuztb2QUwWR3HFViJQtygI0oIUE3TlMu+vWzbMI=";
  };

  cargoHash = "sha256-hX2nSBgXctAHGqvP/ZmMjGJf7C/wPJ/gL+gV7uI8gco=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ rustPlatform.bindgenHook ];
  buildInputs = [ acl ];

  meta = with lib; {
    description = "Transform Linux Audit logs for SIEM usage";
    homepage = "https://github.com/threathunters-io/laurel";
    changelog = "https://github.com/threathunters-io/laurel/releases/tag/v${version}";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ emilylange ];
=======
    maintainers = with maintainers; [ indeednotjames ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
  };
}
