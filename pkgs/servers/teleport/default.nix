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
    sha256 = "sha256-ir2NMNIjSpv7l6dVNHczARg6b+doFofinsJy1smEC7o=";
  };
  version = "8.1.3";

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
    rev = "ea3c67c941c56cfb6c228612e88100df09fb6f9c";
    sha256 = "sha256-oKvDXkxA73IJOi+ciBFVLkYcmeRUsTC+3rcYf64vDoY=";
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
