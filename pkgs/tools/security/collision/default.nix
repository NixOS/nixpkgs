{ lib
, fetchFromGitHub
, crystal
, gtk4
, libadwaita
, openssl
, wrapGAppsHook4
, pkg-config
, gobject-introspection
, gettext
, runCommand
}:

crystal.buildCrystalPackage rec {
  pname = "collision";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Collision";
    rev = "v${version}";
    hash = "sha256-2yg5VmWf6lPHEzPvTCca9LGiLuzJPZ0pZHucHLsliiE=";
  };

  shardsFile = ./shards.nix;

  crystalBinaries.collision.src = "src/collision.cr";

  nativeBuildInputs = [
    wrapGAppsHook4
    pkg-config
    gobject-introspection
    gettext
  ];

  buildInputs = [
    gtk4
    libadwaita
    openssl
  ];

  preBuild = ''
    substituteInPlace Makefile --replace 'PREFIX ?= /usr' "PREFIX ?= $out"
    make bindings
  '';

  installPhase = ''
    runHook preInstall

    make gressource
    make metainfo
    make desktop
    make install_nautilus_extension
    make install

    runHook postInstall
  '';

  passthru.test.crystal-spec = runCommand "${pname}-test" {} ''
    make test
  '';

  meta = with lib; {
    description = "A GUI tool to generate, compare and verify MD5, SHA-1, SHA-256 & SHA-512 hashes";
    homepage = "https://github.com/GeopJr/Collision";
    license = licenses.bsd2;
    maintainers = with maintainers; [ annaaurora ];
  };
}
