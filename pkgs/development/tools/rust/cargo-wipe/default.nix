{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-wipe";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "mihai-dinculescu";
    repo = "cargo-wipe";
    rev = "v${version}";
    sha256 = "sha256-AlmXq2jbU8mQ23Q64a8QiKXwiWkIfr98vAoq7FLImhA=";
  };

  cargoSha256 = "sha256-vsN4cM4Q9LX1ZgAA5x7PupOTh0IcjI65xzuCPjy8YOs=";

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = ''Cargo subcommand "wipe": recursively finds and optionally wipes all "target" or "node_modules" folders'';
    homepage = "https://github.com/mihai-dinculescu/cargo-wipe";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ otavio ];
  };
}
