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
, withExtraFeatures ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-Asjm3IoAfzphITLQuNh6r/i/pjEM/A+wpCsAB83bu2U=";
  };

  cargoSha256 = "sha256-Ly59mdUzSI2pIPbckWn1WBz/o2zVzpAzaCDROLdjG7Y=";

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals (withExtraFeatures && stdenv.isLinux) [ python3 ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ zlib libiconv Security ]
    ++ lib.optionals (withExtraFeatures && stdenv.isLinux) [ xorg.libX11 ]
    ++ lib.optionals (withExtraFeatures && stdenv.isDarwin) [ AppKit nghttp2 libgit2 ];

  cargoBuildFlags = lib.optional withExtraFeatures "--features=extra";

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
