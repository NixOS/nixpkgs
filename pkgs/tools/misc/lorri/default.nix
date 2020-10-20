{ stdenv
, pkgs
, fetchFromGitHub
, rustPlatform
  # Updater script
, runtimeShell
, writers
  # Tests
, nixosTests
  # Apple dependencies
, CoreServices
, Security
}:

(rustPlatform.buildRustPackage rec {
  pname = "lorri";
  version = "1.1.1";

  meta = with stdenv.lib; {
    description = "Your project's nix-env";
    homepage = "https://github.com/target/lorri";
    license = licenses.asl20;
    maintainers = with maintainers; [ grahamc Profpatsch ];
  };

  src = fetchFromGitHub {
    owner = "target";
    repo = pname;
    # Run `eval $(nix-build -A lorri.updater)` after updating the revision!
    # ALSO don’t forget to update the cargoSha256!
    rev = "05ea21170a18800e83b3dcf1e3d347f83a9fa992";
    sha256 = "1lgig5q1anmmmc1i1qnbx8rd8mqvm5csgnlaxlj4l4rxjmgiv06n";
  };

  cargoSha256 = "1nz1g1r94i81b728y0c5szfvxfkz9bqry3xag22alrhjhlc66kpp";
  doCheck = false;

  BUILD_REV_COUNT = src.revCount or 1;
  RUN_TIME_CLOSURE = pkgs.callPackage ./runtime.nix {};

  nativeBuildInputs = with pkgs; [ rustPackages.rustfmt ];
  buildInputs =
    stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security ];

  # copy the docs to the $man and $doc outputs
  postInstall = ''
    install -Dm644 lorri.1 $man/share/man/man1/lorri.1
    install -Dm644 -t $doc/share/doc/lorri/ \
      README.md \
      CONTRIBUTING.md \
      LICENSE \
      MAINTAINERS.md
    cp -r contrib/ $doc/share/doc/lorri/contrib
  '';

  passthru = {
    updater = writers.writeBash "copy-runtime-nix.sh" ''
      set -euo pipefail
      cp ${src}/nix/runtime.nix ${toString ./runtime.nix}
      cp ${src}/nix/runtime-closure.nix.template ${toString ./runtime-closure.nix.template}
    '';
    tests = {
      nixos = nixosTests.lorri;
    };
  };
}).overrideAttrs (old: {
  # add man and doc outputs to put our documentation into
  outputs = old.outputs or [ "out" ] ++ [ "man" "doc" ];
})
