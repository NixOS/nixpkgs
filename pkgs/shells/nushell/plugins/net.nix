{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, IOKit
, CoreFoundation
, unstableGitUpdater
}:

rustPlatform.buildRustPackage {
  pname = "nu-plugin-net";
  version = "unstable-2023-10-24";

  src = fetchFromGitHub {
    owner = "fennewald";
    repo = "nu_plugin_net";
    rev = "8b63996ea2ff8bf282c9b0f5f6d01960cfe3d074";
    hash = "sha256-QFo2cMI41GDBsuPNay5MyVyY+HdrLjAWedz8kDNA3JY=";
  };

  cargoHash = "sha256-ekfUQOsaWdpDASnRzoYh5Y/p3BnP7rvSYCCWQ6DJDnE=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    IOKit
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A nushell plugin to list system network interfaces";
    homepage = "https://github.com/fennewald/nu_plugin_net";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "nu-plugin-net";
  };
}
