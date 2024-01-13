{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "askalono";
  version = "0.4.6";

  src = fetchCrate {
    pname = "askalono-cli";
    inherit version;
    hash = "sha256-7l5bHSsmuMoHbbOI3TAYFeHwD3Y62JvfrrXZa08V3+U=";
  };

  cargoHash = "sha256-OkN8V37GApJvremRJlWG3HSpWgMC17Ge8JMTiQVoc/g=";

  meta = with lib; {
    description = "A tool to detect open source licenses from texts";
    homepage = "https://github.com/jpeddicord/askalono";
    changelog = "https://github.com/jpeddicord/askalono/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "askalono";
  };
}
