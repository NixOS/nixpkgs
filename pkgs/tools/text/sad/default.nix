{ lib
, fetchFromGitHub
, rustPlatform
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "sad";
  version = "0.4.23";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LNMc+3pXx7VyNq0dws+s13ZA3+f8aJzgbAxzI71NKx0=";
  };

  cargoHash = "sha256-UjXJmH4UI5Vey2rBy57CI1r13bpGYhIozEoOoyoRDLQ=";

  nativeBuildInputs = [ python3 ];

  # fix for compilation on aarch64
  # see https://github.com/NixOS/nixpkgs/issues/145726
  prePatch = ''
    rm .cargo/config.toml
  '';

  meta = with lib; {
    description = "CLI tool to search and replace";
    homepage = "https://github.com/ms-jpq/sad";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
