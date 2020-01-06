{ stdenv
, pkgs
, fetchFromGitHub
, rustPlatform
  # Updater script
, runtimeShell
, writeScript
  # Tests
, nixosTests
  # Apple dependencies
, CoreServices
, Security
}:

let
  pname = "lorri";
  owner = "target";
  homepage = "https://github.com/${owner}/${pname}";
  repoUrl = "${homepage}.git";

  # Run `eval $(nix-build -A lorri.updater)` after updating the revision!
  rev = "03f10395943449b1fc5026d3386ab8c94c520ee3";
in
rustPlatform.buildRustPackage rec {
  inherit pname;
  version = "unstable-2019-10-30";

  meta = with stdenv.lib; {
    inherit homepage;
    description = "Your project's nix-env";
    license = licenses.asl20;
    maintainers = with maintainers; [ grahamc Profpatsch ];
  };

  src = fetchFromGitHub {
    inherit rev owner;
    repo = pname;
    sha256 = "0fcl79ndaziwd8d74mk1lsijz34p2inn64b4b4am3wsyk184brzq";
  };

  cargoSha256 = "1daff4plh7hwclfp21hkx4fiflh9r80y2c7k2sd3zm4lmpy0jpfz";
  doCheck = false;

  # Run `eval $(nix-build -A lorri.updater)` after updating the revision to
  # update BUILD_REV_COUNT.
  BUILD_REV_COUNT = 310;

  RUN_TIME_CLOSURE = pkgs.callPackage ./runtime.nix {};

  nativeBuildInputs = with pkgs; [ nix direnv which ];
  buildInputs =
    stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security ];

  passthru = {
    updater = with builtins; writeScript "copy-runtime-nix.sh" ''
      #!${runtimeShell}
      set -euo pipefail
      cp ${src}/nix/runtime.nix ${toString ./runtime.nix}
      cp ${src}/nix/runtime-closure.nix.template ${toString ./runtime-closure.nix.template}

      TMP=$(mktemp -d)
      pushd $TMP > /dev/null
      git clone ${repoUrl} > /dev/null 2> /dev/null
      cd lorri
      git checkout ${rev} > /dev/null 2> /dev/null
      REV_COUNT="$(git log --pretty=%h | wc -l)"
      popd > /dev/null
      rm -rf $TMP

      echo "BUILD_REV_COUNT = $REV_COUNT"
      sed -i -e "s/^  BUILD_REV_COUNT = .\+;$/  BUILD_REV_COUNT = $REV_COUNT;/" ${toString ./default.nix}
    '';
    tests = {
      nixos = nixosTests.lorri;
    };
  };
}
