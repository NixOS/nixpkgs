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
, nghttp2
, libgit2
, withStableFeatures ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1wj054rzv88ys4ask4zp7crrw0dxrck8svlj3i16qqd8x5dnyhqs";
  };

  cargoSha256 = "09ph3njll9assk85yh5pyvpsab3nk0mvxrdpqhy5rwps1478w0cq";

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals (withStableFeatures && stdenv.isLinux) [ python3 ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ zlib libiconv Security ]
    ++ lib.optionals (withStableFeatures && stdenv.isLinux) [ xorg.libX11 ]
    ++ lib.optionals (withStableFeatures && stdenv.isDarwin) [ AppKit nghttp2 libgit2 ];

  cargoBuildFlags = lib.optional withStableFeatures "--features stable";

  # TODO investigate why tests are broken on darwin
  # failures show that tests try to write to paths
  # outside of TMPDIR
  doCheck = ! stdenv.isDarwin;

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
    mainProgram = "nu";
  };

  passthru = {
    shellPath = "/bin/nu";
  };
}
