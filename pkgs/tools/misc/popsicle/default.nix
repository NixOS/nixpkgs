{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, glib
, pkg-config
, gdk-pixbuf
, gtk3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "popsicle";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = version;
    sha256 = "sha256-NqzuZmVabQ5WHOlBEsJhL/5Yet3TMSuo/gofSabCjTY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sha256 = "sha256-k2M1c9kk1blE0ZKjstDQANdbUzI4oS1Ho5P+sR4cRtg=";
  };

  nativeBuildInputs = [
    glib
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf
    gtk3
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  meta = with lib; {
    description = "Multiple USB File Flasher";
    homepage = "https://github.com/pop-os/popsicle";
    changelog = "https://github.com/pop-os/popsicle/releases/tag/${version}";
    maintainers = with maintainers; [ _13r0ck figsoda ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
