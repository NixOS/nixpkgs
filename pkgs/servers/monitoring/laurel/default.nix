{
  acl,
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "laurel";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "threathunters-io";
    repo = "laurel";
    rev = "refs/tags/v${version}";
    hash = "sha256-mp1XTFD6mvH3RzvzvnJ58iJ6/EjENKYSzOavC2rVixs=";
  };

  cargoHash = "sha256-F5yMNm1JaE9q0NQJ3PDmPlW4WdjfyJj/J9er18acsKw=";

  postPatch = ''
    # Upstream started to redirect aarch64-unknown-linux-gnu to aarch64-linux-gnu-gcc
    # for their CI which breaks compiling on aarch64 in nixpkgs:
    #  error: linker `aarch64-linux-gnu-gcc` not found
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [ rustPlatform.bindgenHook ];
  buildInputs = [ acl ];

  meta = with lib; {
    description = "Transform Linux Audit logs for SIEM usage";
    homepage = "https://github.com/threathunters-io/laurel";
    changelog = "https://github.com/threathunters-io/laurel/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ emilylange ];
    platforms = platforms.linux;
  };
}
