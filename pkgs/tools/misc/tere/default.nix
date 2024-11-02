{ lib, fetchFromGitHub, rustPlatform, ncurses, stdenv, python3 }:

rustPlatform.buildRustPackage {
  pname = "tere";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "mgunyho";
    repo = "tere";
    rev = "5adf1176e8c12c073ad244cac7773a7808ed2021";
    sha256 = "sha256-oY4oeSttM8LLXLirYq/B7Nzajkg4Pw26uig5gZxqU3s=";
  };

  cargoHash = "sha256-UWZWm6wDiQqUNcWV1nDUWXVhWgqoVUCDWz09cRkiPKg=";

  nativeBuildInputs = [
    # ncurses provides the tput command needed for integration tests
    # https://github.com/mgunyho/tere/issues/93#issuecomment-2029624187
    ncurses
  ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # Unexplained fail
    # https://github.com/NixOS/nixpkgs/pull/298527#issuecomment-2053758845
    "--skip=first_run_prompt_accept"
  ];

  # NOTE: workaround for build fail on aarch64
  # See https://github.com/NixOS/nixpkgs/issues/145726#issuecomment-971331986
  preBuild =
    let
      python-with-toml = python3.withPackages (ps: [ps.toml]);
      script = builtins.toFile "clear_linkers.py" ''
        from os import path
        import toml

        if path.exists(".cargo/config.toml"):
          config = toml.load(open(".cargo/config.toml"))

          for target in config.get("target",{}).values():
            if "linker" in target:
              del target["linker"]

          toml.dump(config,open(".cargo/config.toml", "w"))
        else:
          print(__file__, ":  CONFIG.TOML EXPECTED")
          exit(1)
      '';
    in
      "${python-with-toml}/bin/python3 ${script}";

  meta = with lib; {
    description = "Faster alternative to cd + ls";
    homepage = "https://github.com/mgunyho/tere";
    license = licenses.eupl12;
    maintainers = with maintainers; [ ProducerMatt ];
    mainProgram = "tere";
  };
}
