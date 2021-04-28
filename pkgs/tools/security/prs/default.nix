{ lib
, rustPlatform
, fetchFromGitLab
, installShellFiles
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
  version = "0.2.9";

  src = fetchFromGitLab {
    owner = "timvisee";
    repo = "prs";
    rev = "v${version}";
    sha256 = "sha256-9qaRhTfdppU72w8jDwD1e8ABuGG+9GyrRIUVsry4Vos=";
  };

  cargoSha256 = "sha256-j+kyllMcYj7/Ig5ho548L1wW+TtuQOc/zkxT6SNNN6w=";

  postPatch = ''
    # The GPGME backend is recommended
    for f in "gtk3/Cargo.toml" "cli/Cargo.toml"; do
      substituteInPlace "$f" --replace \
        'default = ["backend-gnupg-bin"' 'default = ["backend-gpgme"'
    done
  '';

  nativeBuildInputs = [ gpgme installShellFiles pkg-config python3 ];

  buildInputs = [ dbus glib gpgme gtk3 libxcb ];

  postInstall = ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd prs --$shell <($out/bin/prs internal completions $shell --stdout)
    done
  '';

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
