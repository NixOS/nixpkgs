{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, fetchpatch
, pkg-config
, openssl
, testers
, gbl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "gbl";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "dac-gmbh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Xzx14fvYWTZYM9Pnowf1M3D0PTPRLwsXHUj/PJskRWw=";
  };

  cargoPatches = [
    # update ring to fix building on Mac M1
    # https://github.com/dac-gmbh/gbl/pull/64
    (fetchpatch {
      url = "https://github.com/raboof/gbl/commit/17e154d66932af59abe8677309792606b7f64c7d.patch";
      sha256 = "sha256-5Itoi86Q+9FzSTtnggODKPwwYPp5BpIVgR2vYMLHBts=";
    })
    # Upstream does not include Cargo.lock, even though this is recommended for applications.
    (fetchpatch {
      url = "https://github.com/raboof/gbl/commit/9423d36ee3168bca8db7a7cb65611dc7ddc2daf0.patch";
      sha256 = "sha256-zwHXgUVkAYiQs/AT/pINnZoECoXzh+9astWMYENGTL8=";
    })
  ];

  cargoHash = "sha256-CeGLSseKUe2XudRqZm5Y7o7ZLDtDBg/MFunOGqxFZGM=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  passthru.tests.version =
    testers.testVersion { package = gbl; };

  meta = with lib; {
    description = "GBL Firmware file manipulation";
    longDescription = ''
      Utility to read, create and manipulate `.gbl` firmware update
      files targeting the Silicon Labs Gecko Bootloader.
    '';
    homepage = "https://github.com/jonas-schievink/gbl";
    license = licenses.mit;
    maintainers = [ maintainers.raboof ];
    mainProgram = "gbl";
  };
}
