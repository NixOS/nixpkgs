{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, openssl
, zlib
, pkg-config
, python3
, xorg
, libiconv
, AppKit
, Security
, withStableFeatures ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "104zrj15kmc0a698dc8dxbzhg1rjqn38v3wqcwg2xiickglpgd5f";
  };

  cargoSha256 = "1c6yhkj1hyr82y82nff6gy9kq9z0mbq3ivlq8rir10pnqy4j5791";

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals (withStableFeatures && stdenv.isLinux) [ python3 ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ zlib libiconv Security ]
    ++ lib.optionals (withStableFeatures && stdenv.isLinux) [ xorg.libX11 ]
    ++ lib.optionals (withStableFeatures && stdenv.isDarwin) [ AppKit ];

  cargoBuildFlags = lib.optional withStableFeatures "--features stable";

  checkPhase = ''
    runHook preCheck
    echo "Running cargo test"
    HOME=$TMPDIR cargo test
    runHook postCheck
  '';

  meta = with lib; {
    description = "A modern shell written in Rust";
    homepage = "https://www.nushell.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne johntitor marsam ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" ];
    mainProgram = "nu";
  };

  passthru = {
    shellPath = "/bin/nu";
  };
}
