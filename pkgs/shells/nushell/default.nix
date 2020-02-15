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
, withTestBinaries ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0p1aykhkz5rixj6x0rskg77q31xw11mirvjhzp7n4nmbx3rfkagc";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "0143mm9cdswd1azpzzpbfc5x7dy3ryywvq44mwkd6h1027n5idap";

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals (withStableFeatures && stdenv.isLinux) [ python3 ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ]
    ++ lib.optionals (withStableFeatures && stdenv.isLinux) [ xorg.libX11 ]
    ++ lib.optionals (withStableFeatures && stdenv.isDarwin) [ AppKit ];

  cargoBuildFlags = lib.optional withStableFeatures "--features stable";

  cargoTestFlags = lib.optional withTestBinaries "--features test-bins";

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkPhase = ''
    runHook preCheck
    echo "Running cargo cargo test ${lib.strings.concatStringsSep " " cargoTestFlags} -- ''${checkFlags} ''${checkFlagsArray+''${checkFlagsArray[@]}}"
    cargo test ${lib.strings.concatStringsSep " " cargoTestFlags} -- ''${checkFlags} ''${checkFlagsArray+"''${checkFlagsArray[@]}"}
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
