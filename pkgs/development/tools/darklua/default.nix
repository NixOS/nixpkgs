{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "darklua";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "seaofvoices";
    repo = "darklua";
    rev = "v${version}";
    hash = "sha256-ABzhtAbWv2oM4VqxRUWC+xh2fwUw1s2iU1IWb5EEhiE=";
  };

  cargoHash = "sha256-36YN/7aI69xsnwGz8oQG5RZu8XjQ9vwQtRNMWQ7pT0Q=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = with lib; {
    description = "A command line tool that transforms Lua code";
    homepage = "https://darklua.com";
    changelog = "https://github.com/seaofvoices/darklua/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ tomodachi94 ];
  };
}
