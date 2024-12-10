{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  elfutils,
  makeBinaryWrapper,
  pkg-config,
  xz,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "pwninit";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "io12";
    repo = "pwninit";
    rev = version;
    sha256 = "sha256-tbZS7PdRFvO2ifoHA/w3cSPfqqHrLeLHAg6V8oG9gVE=";
  };

  buildInputs = [
    openssl
    xz
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];
  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];
  postInstall = ''
    wrapProgram $out/bin/pwninit \
      --prefix PATH : "${lib.getBin elfutils}/bin"
  '';
  doCheck = false; # there are no tests to run

  cargoHash = "sha256-J2uQoqStBl+qItaXWi17H/IailZ7P4YzhLNs17BY92Q=";

  meta = {
    description = "Automate starting binary exploit challenges";
    mainProgram = "pwninit";
    homepage = "https://github.com/io12/pwninit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.scoder12 ];
    platforms = lib.platforms.all;
  };
}
