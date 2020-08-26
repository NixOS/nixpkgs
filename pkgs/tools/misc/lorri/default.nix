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

let
  # Run `eval $(nix-build -A lorri.updater)` after updating the revision!
  version = "1.2";
  gitRev = "43a260c221d5dac4a44fd82271736c8444474eec";
  sha256 = "0g6zq27dpr8bdan5xrqchybpbqwnhhc7x8sxbfygigbqd3xv9i6n";
  cargoSha256 = "1zmlp14v7av0znmjyy2aq83lc74503p6r0l11l9iw7s3xad8rda4";

in (rustPlatform.buildRustPackage rec {
  pname = "lorri";
  inherit version;

  meta = with stdenv.lib; {
    description = "Your project's nix-env";
    homepage = "https://github.com/target/lorri";
    license = licenses.asl20;
    maintainers = with maintainers; [ grahamc Profpatsch ];
  };

  src = fetchFromGitHub {
    owner = "target";
    repo = pname;
    rev = gitRev;
    inherit sha256;
  };

  inherit cargoSha256;
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
