{ fetchFromGitHub
, installShellFiles
, lib
, rustPlatform
, scdoc
}:

rustPlatform.buildRustPackage rec {
  pname = "uair";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "metent";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cxSNBxs6ixbjWMUYzOnwI+vavkfyaQx3/OmVdTCr7M0=";
  };

  cargoHash = "sha256-cDIF4RvJ7K6t18GPgiRV6NDoD/x3II/3wCHW3KK2/os=";

  nativeBuildInputs = [ installShellFiles scdoc ];

  preFixup = ''
    scdoc < docs/uair.1.scd > docs/uair.1
    scdoc < docs/uair.5.scd > docs/uair.5
    scdoc < docs/uairctl.1.scd > docs/uairctl.1

    installManPage docs/*.[1-9]
  '';

  meta = with lib; {
    description = "Extensible pomodoro timer";
    homepage = "https://github.com/metent/uair";
    license = licenses.mit;
    maintainers = with maintainers; [ thled ];
  };
}
