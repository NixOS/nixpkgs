{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, openssl
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
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0d298v7rf8lxdavhfad68rq4sgmg6gw6vc7phh1lnhx5pbhkvv22";
  };

  cargoSha256 = "0xibrdbqfmmkncqpjsllzx1w79crm0v4liwf2aldnafji7jqclb4";

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals (withStableFeatures && stdenv.isLinux) [ python3 ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ]
    ++ lib.optionals (withStableFeatures && stdenv.isLinux) [ xorg.libX11 ]
    ++ lib.optionals (withStableFeatures && stdenv.isDarwin) [ AppKit ];

  cargoBuildFlags = lib.optional withStableFeatures "--features stable";

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkPhase = ''
    runHook preCheck
    echo "Running cargo test"
    cargo test
    runHook postCheck
  '';

  meta = with lib; {
    description = "A modern shell written in Rust";
    homepage = "https://www.nushell.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 marsam ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };

  passthru = {
    shellPath = "/bin/nu";
  };
}
