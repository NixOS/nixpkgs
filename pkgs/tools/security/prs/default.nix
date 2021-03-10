{ lib
, rustPlatform
, fetchFromGitLab
, pkg-config
, python3
, dbus
, glib
, gpgme
, gtk3
, libxcb
}:

rustPlatform.buildRustPackage rec {
  pname = "prs";
  version = "0.2.3";

  src = fetchFromGitLab {
    owner = "timvisee";
    repo = "prs";
    rev = "v${version}";
    sha256 = "sha256-aulrMXKKCFo8nU6mEplcpaGGMfLr03FCgIF6rg6LqGg=";
  };

  cargoSha256 = "sha256-996iwBOp5F9q9/yptTHtsLj6wlY5HEpp8CWTbpBWPuA=";

  postPatch = ''
    # The GPGME backend is recommended
    for f in "gtk3/Cargo.toml" "cli/Cargo.toml"; do
      substituteInPlace "$f" --replace \
        'default = ["backend-gnupg-bin"' 'default = ["backend-gpgme"'
    done
  '';

  nativeBuildInputs = [ gpgme pkg-config python3 ];

  buildInputs = [ dbus glib gpgme gtk3 libxcb ];

  meta = with lib; {
    description = "Secure, fast & convenient password manager CLI using GPG and git to sync";
    homepage = "https://gitlab.com/timvisee/prs";
    changelog = "https://gitlab.com/timvisee/prs/-/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      lgpl3Only # lib
      gpl3Only  # everything else
    ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
