{ fetchFromGitHub
, installShellFiles
, lib
, rustPlatform
, scdoc
}:

rustPlatform.buildRustPackage rec {
  pname = "uair";
  version = "v0.4.0";

  src = fetchFromGitHub {
    owner = "metent";
    repo = pname;
    rev = version;
    hash = "sha256-xGPc371Dfo455rnfacXVDgC9SXU5s8jqw4ttSCBqWyk=";
  };

  cargoHash = "sha256-tHcMR8ExIlzYZzacBYyyk2d5by20jG4ihM0yU0K6Xhg=";

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
