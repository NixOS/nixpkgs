{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, binutils
, dpkg
}:
let
  # cargo-deb expects "strip" and "objcopy" from binutils to be on the PATH.
  binutilsBinPath = lib.makeBinPath [ binutils ];
in
rustPlatform.buildRustPackage rec {
  pname = "cargo-deb";
  version = "1.44.0";

  src = fetchFromGitHub {
    owner = "kornelski";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1gA8r/4VMiBWTU0Q0rlSxANt9oK3nYx/cqq0WxvNNZs=";
  };

  cargoHash = "sha256-Fg0KkAqcjAGFEDaAge4KFAFBBfVSGE6lIoewDcLEFug=";

  nativeBuildInputs = [
    makeWrapper
  ];

  preCheck = ''
    export PATH="${binutilsBinPath}":$PATH

    substituteInPlace tests/command.rs \
      --replace '"stripped executable should be smaller than debug executable"' '"stripped executable {} should be smaller than debug executable {}", stripped.metadata().unwrap().len(), debug.metadata().unwrap().len()'
  '';

  # This is an FHS specific assert depending on glibc location
  checkFlags = [
    "--skip=dependencies::resolve_test"
  ];

  postInstall = ''
    wrapProgram $out/bin/cargo-deb \
      --prefix PATH : "${lib.makeBinPath [ dpkg ]}" \
      --prefix PATH : "${binutilsBinPath}"
  '';

  meta = with lib; {
    description = "A cargo subcommand that generates Debian packages from information in Cargo.toml";
    homepage = "https://github.com/kornelski/cargo-deb";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
