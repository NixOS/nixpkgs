{ lib
, buildGoModule
, fetchFromSourcehut
}:

buildGoModule rec {
  pname = "qcard";
  version = "0.7.1";

  src = fetchFromSourcehut {
    owner = "~psic4t";
    repo = "qcard";
    rev = version;
    hash = "sha256-OwmJSeAOZTX7jMhoLHSIJa0jR8zCadISQF/PqFqltRY=";
  };

  vendorHash = null;

  # Replace "config-sample.json" in error message with the absolute path
  # to that config file in the nix store
  preBuild = ''
    substituteInPlace helpers.go \
      --replace " config-sample.json " " $out/share/qcard/config-sample.json "
  '';

  postInstall = ''
    mkdir -p $out/share/qcard
    cp config-sample.json $out/share/qcard/
  '';

  meta = {
    description = "CLI addressbook application for CardDAV servers written in Go";
    homepage = "https://git.sr.ht/~psic4t/qcard";
    license = lib.licenses.gpl3Plus;
    mainProgram = "qcard";
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
