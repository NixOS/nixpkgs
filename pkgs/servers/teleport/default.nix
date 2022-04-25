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
    sha256 = "sha256-KQfdeMuZ9LJHhEJLMl58Yb0+gxgDT7VcVnK1JxjVZaI=";
  };
  version = "9.1.2";

  roleTester = rustPlatform.buildRustPackage {
    name = "teleport-roletester";
    inherit version src;

    cargoSha256 = "sha256-gCm4ETbXy6tGJQVSzUkoAWUmKD3poYgkw133LtziASI=";
    buildAndTestSubdir = "lib/datalog/roletester";

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
    sha256 = "sha256-o4qjXGaNi5XDSUQrUuU+G77EdRnvJ1WUPWrryZU1CUE=";
  };
in
buildGoModule rec {
  pname = "teleport";

  inherit src version;
  vendorSha256 = "sha256-UMgWM7KHag99JR4i4mwVHa6yd9aHQ6Dy+pmUijNL4Ew=";

  subPackages = [ "tool/tbot" "tool/tctl" "tool/teleport" "tool/tsh" ];
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
      "cp -r ${roleTester}/target ."}
  '';

  # Multiple tests fail in the build sandbox
  # due to trying to spawn nixbld's shell (/noshell), etc.
  doCheck = false;

  postInstall = ''
    install -Dm755 -t $client/bin $out/bin/tsh
    wrapProgram $client/bin/tsh --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
    wrapProgram $out/bin/tsh --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/tsh version | grep ${version} > /dev/null
    $client/bin/tsh version | grep ${version} > /dev/null
    $out/bin/tbot version | grep ${version} > /dev/null
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
