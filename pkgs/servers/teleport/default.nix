{ lib
, buildGoModule
, rustPlatform
, fetchFromGitHub
, makeWrapper
, protobuf
, stdenv
, xdg-utils
, nixosTests

, withRoleTester ? true
}:
let
  # This repo has a private submodule "e" which fetchgit cannot handle without failing.
  src = fetchFromGitHub {
    owner = "gravitational";
    repo = "teleport";
    rev = "v${version}";
    sha256 = "1w46pzfy552lxs368hylqlcb7fbh7ank3g9w0x9py54xq5mfy2ml";
  };
  version = "9.0.4";

  roleTester = rustPlatform.buildRustPackage {
    name = "teleport-roletester";
    inherit version;

    src = "${src}/lib/datalog";
    cargoSha256 = "sha256-cpW7kel02t/fB2CvDvVqWlzgS3Vg2qLnemF/bW2Ii1A=";
    sourceRoot = "datalog/roletester";

    PROTOC = "${protobuf}/bin/protoc";
    PROTOC_INCLUDE = "${protobuf}/include";

    postInstall = ''
      cp -r target $out
    '';
  };

  webassets = fetchFromGitHub {
    owner = "gravitational";
    repo = "webassets";
    rev = "67e608db77300d8a6cb17709be67f12c1d3271c3";
    sha256 = "0h896nawksva7na5a9zg35sw9ghv7vjm4as4971rb2wdcrfa72m3";
  };
in
buildGoModule rec {
  pname = "teleport";

  inherit src version;
  vendorSha256 = null;

  subPackages = [ "tool/tctl" "tool/teleport" "tool/tsh" ];
  tags = [ "webassets_embed" ] ++
    lib.optional withRoleTester "roletester";

  nativeBuildInputs = [ makeWrapper ];

  patches = [
    # https://github.com/NixOS/nixpkgs/issues/120738
    ./tsh.patch
    # https://github.com/NixOS/nixpkgs/issues/132652
    ./test.patch
    ./0001-fix-add-nix-path-to-exec-env.patch
  ];

  # Reduce closure size for client machines
  outputs = [ "out" "client" ];

  preBuild = ''
    mkdir -p build
    echo "making webassets"
    cp -r ${webassets}/* webassets/
    make lib/web/build/webassets

    ${lib.optionalString withRoleTester
      "cp -r ${roleTester}/target lib/datalog/roletester/."}
  '';

  doCheck = !stdenv.isDarwin;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = ''
    install -Dm755 -t $client/bin $out/bin/tsh
    wrapProgram $client/bin/tsh --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
    wrapProgram $out/bin/tsh --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/tsh version | grep ${version} > /dev/null
    $client/bin/tsh version | grep ${version} > /dev/null
    $out/bin/tctl version | grep ${version} > /dev/null
    $out/bin/teleport version | grep ${version} > /dev/null
  '';

  passthru.tests = nixosTests.teleport;

  meta = with lib; {
    description = "Certificate authority and access plane for SSH, Kubernetes, web applications, and databases";
    homepage = "https://goteleport.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ sigma tomberek freezeboy ];
    platforms = platforms.unix;
  };
}
