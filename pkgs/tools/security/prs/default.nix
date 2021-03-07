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
  version = "0.2.2";

  src = fetchFromGitLab {
    owner = "timvisee";
    repo = "prs";
    rev = "v${version}";
    sha256 = "05l9zaaadv2a7ngwkxggp5vrjlnpvf2wr4ijhprx3jkw8b2cxii7";
  };

  cargoSha256 = "0fjkvr5mdqiy70qx4liwnh78y6mqdv6vbg3nayinh2h34p0z609y";

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
