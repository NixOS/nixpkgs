{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, dpkg
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deb";
  version = "1.42.2";

  src = fetchFromGitHub {
    owner = "kornelski";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-s/piZ8sCdBz5zFW9i7xdVrf7dQiMjQp/ixCDjFh5SLc=";
  };

  cargoHash = "sha256-4iJghmSXsaijNCvYyrM3dEsqCDk6zeTU92oP5Qs6tOY=";

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
