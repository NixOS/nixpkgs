{ lib
, stdenv
, pkgs
, rustPackages
, fetchFromGitHub
, rustPlatform
, writers
, nixosTests
, CoreServices
, Security
}:

let
  # Run `eval $(nix-build -A lorri.updater)` after updating the revision!
  version = "1.4.0";
  gitRev = "fee4ffac9ee16fc921d413789cc059b043f2db3d";
  sha256 = "sha256:0ix0k85ywlvkxsampajkq521d290gb0n60qwhnk6j0sc55yn558h";
  cargoSha256 = "sha256:1ngn4wnyh6cjnyg7mb48zvng0zn5fcn8s75y88nh91xq9x1bi2d9";

in (rustPlatform.buildRustPackage rec {
  pname = "lorri";
  inherit version;

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = gitRev;
    inherit sha256;
  };

  outputs = [ "out" "man" "doc" ];

  inherit cargoSha256;
  doCheck = false;

  BUILD_REV_COUNT = src.revCount or 1;
  RUN_TIME_CLOSURE = pkgs.callPackage ./runtime.nix { };

  nativeBuildInputs = [ rustPackages.rustfmt ];
  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices Security ];

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

  meta = with lib; {
    description = "Your project's nix-env";
    homepage = "https://github.com/target/lorri";
    license = licenses.asl20;
    maintainers = with maintainers; [ grahamc Profpatsch ];
  };
})
