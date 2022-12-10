{ rustPlatform, lib, fetchFromGitHub, xz, pkg-config, openssl, dbus, glib, udev, cairo, pango, atk, gdk-pixbuf, gtk3, wrapGAppsHook }:
rustPlatform.buildRustPackage rec {
  pname = "firmware-manager";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = version;
    sha256 = "sha256-aKatdjHa/k7j48upkR1O6PFxCUfJYE3KhhzZ9Ohe0Jc=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  buildInputs = [ xz openssl dbus glib udev cairo pango atk gdk-pixbuf gtk3 ];

  depsExtraArgs.postPatch = "make prefix='$(out)' toml-gen";

  postPatch = ''
    sed -i 's|etc|$(prefix)/etc|' Makefile
  '';

  buildPhase = "make prefix='$(out)'";

  installPhase = "make prefix='$(out)' install";

  cargoSha256 = "sha256-BUo77ERHvuc8IkDdU3Z/gZZicNHT26IbAgEBnVM3O4U=";

  doCheck = false;

  meta = {
    description = "Graphical frontend for firmware management";
    homepage = "https://github.com/pop-os/firmware-manager";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.shlevy ];
    platforms = lib.platforms.linux;
  };
}
