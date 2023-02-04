{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, dpkg
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deb";
  version = "1.42.0";

  src = fetchFromGitHub {
    owner = "kornelski";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5IWx9tScm64Rwi6RMsbXl1Eajtc/c5PWaZEDrgibTAY=";
  };

  cargoHash = "sha256-nwCfUxIrr4DxKqePu/vwxfLld08+GGXZwQWz6Gltmao=";

  nativeBuildInputs = [
    makeWrapper
  ];

  # This is an FHS specific assert depending on glibc location
  checkFlags = [
    "--skip=dependencies::resolve_test"
  ];

  postInstall = ''
    wrapProgram $out/bin/cargo-deb \
      --prefix PATH : ${lib.makeBinPath [ dpkg ]}
  '';

  meta = with lib; {
    description = "A cargo subcommand that generates Debian packages from information in Cargo.toml";
    homepage = "https://github.com/kornelski/cargo-deb";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
