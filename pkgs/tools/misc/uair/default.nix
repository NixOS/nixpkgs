{ fetchFromGitHub
, installShellFiles
, lib
, rustPlatform
, scdoc
}:

rustPlatform.buildRustPackage rec {
  pname = "uair";
  version = "v0.5.1";

  src = fetchFromGitHub {
    owner = "metent";
    repo = pname;
    rev = version;
    hash = "sha256-qxfdKU3SFGVpp3OG0m+0qDvs5cB2bAaTF8+K6zwXRnI=";
  };

  cargoHash = "sha256-XmEbXzpynkUPXywaf4wPcWq9zf3gNOHkcVr2jz3WNnc=";

  nativeBuildInputs = [ installShellFiles scdoc ];

  preFixup = ''
    scdoc < docs/uair.1.scd > docs/uair.1
    scdoc < docs/uair.5.scd > docs/uair.5
    scdoc < docs/uairctl.1.scd > docs/uairctl.1

    installManPage docs/*.[1-9]
  '';

  meta = with lib; {
    description = "An extensible pomodoro timer";
    homepage = "https://github.com/metent/uair";
    license = licenses.mit;
    maintainers = with maintainers; [ thled ];
  };
}
