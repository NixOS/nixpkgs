{ lib
, rustPlatform
, fetchCrate
, pkg-config
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "writedisk";
  version = "1.3.0";

  src = fetchCrate {
    inherit version;
    pname = "writedisk";
    sha256 = "sha256-MZFnNb8rJMu/nlH8rfnD//bhqPSkhyXucbTrwsRM9OY=";
  };

  cargoSha256 = "sha256-DGroBBozAViibbIYbtqH2SxIGLqdtyJ9XKyz7O1L05g=";

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Small utility for writing a disk image to a USB drive";
    homepage = "https://github.com/nicholasbishop/writedisk";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ devhell ];
  };
}
