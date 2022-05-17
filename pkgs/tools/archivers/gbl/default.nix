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
    # Upstream does not include Cargo.lock, even though this is recommended for applications.
    # This patch adds it. https://github.com/dac-gmbh/gbl/pull/62
    (fetchpatch {
      url = "https://github.com/raboof/gbl/commit/99078da334c6e1ffd8189c691bbc711281fae5cc.patch";
      sha256 = "sha256-sAKkn4//8P87ZJ6NTHm2NUJH1sAFFwfrybv2QtQ3nnM=";
    })
  ];

  cargoSha256 = "sha256-RUZ6wswRtV8chq3+bY9LTRf6IYMbZ9/GPl2X5UcF7d8=";

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
    homepage = "https://github.com/dac-gmbh/gbl";
    license = licenses.mit;
    maintainers = [ maintainers.raboof ];
  };
}
