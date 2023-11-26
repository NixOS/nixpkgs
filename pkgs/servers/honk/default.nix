{ lib
, buildGoModule
, fetchurl
, sqlite
, installShellFiles
, nixosTests
}:

buildGoModule rec {
  pname = "honk";
  version = "1.1.1";

  src = fetchurl {
    url = "https://humungus.tedunangst.com/r/honk/d/honk-${version}.tgz";
    hash = "sha256-kfoSVGm1QKVjDiWvjK4QzAoA/iiU9j6DS3SYFSM+AaA=";
  };
  vendorHash = null;

  buildInputs = [
    sqlite
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "." ];

  # This susbtitution is not mandatory. It is only existing to have something
  # working out of the box. This value can be overriden by the user, by
  # providing the `-viewdir` parameter in the command line.
  postPatch = ''
    substituteInPlace main.go --replace \
      "var viewDir = \".\"" \
      "var viewDir = \"$out/share/honk\""
  '';

  postInstall = ''
    mkdir -p $out/share/${pname}
    mkdir -p $out/share/doc/${pname}

    mv docs/{,honk-}intro.1
    mv docs/{,honk-}hfcs.1
    mv docs/{,honk-}vim.3
    mv docs/{,honk-}activitypub.7

    installManPage docs/honk.1 docs/honk.3 docs/honk.5 docs/honk.8 \
      docs/honk-intro.1 docs/honk-hfcs.1 docs/honk-vim.3 docs/honk-activitypub.7
    mv docs/{*.html,*.txt,*.jpg,*.png} $out/share/doc/${pname}
    mv views $out/share/${pname}
  '';

  passthru.tests = {
    inherit (nixosTests) honk;
  };

  meta = {
    changelog = "https://humungus.tedunangst.com/r/honk/v/v${version}/f/docs/changelog.txt";
    description = "An ActivityPub server with minimal setup and support costs.";
    homepage = "https://humungus.tedunangst.com/r/honk";
    license = lib.licenses.isc;
    mainProgram = "honk";
    maintainers = with lib.maintainers; [ huyngo ];
  };
}
