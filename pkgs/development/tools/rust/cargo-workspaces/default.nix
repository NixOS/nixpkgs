{ lib
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-workspaces";
  version = "0.2.34";

  src = fetchFromGitHub {
    owner = "pksunkara";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7oJ/jjrv2XbOyLKUqp7EMFGR+czNSXCpWI8/JX5kmH8=";
  };

  cargoSha256 = "sha256-vZyodSxQd89dyaw4lr8vsbNjztXhFVgD0FcBP8KdPss=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  sourceRoot = "source";
  cargoRoot = pname;
  buildAndTestSubdir = pname;

  meta = with lib; {
    description = "A tool for managing cargo workspaces and their crates";
    homepage = "https://github.com/pksunkara/cargo-workspaces";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ cjab ];
  };
}
