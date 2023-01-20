{ lib
, buildGoModule
, rustPlatform
, fetchFromGitHub
, makeWrapper
, symlinkJoin
, CoreFoundation
, libfido2
, openssl
, pkg-config
, protobuf
, Security
, stdenv
, xdg-utils
, nixosTests

, withRdpClient ? true
}:
let
  # This repo has a private submodule "e" which fetchgit cannot handle without failing.
  src = fetchFromGitHub {
    owner = "gravitational";
    repo = "teleport";
    rev = "v${version}";
    hash = "sha256-F5v3/eKPLhSxW7FImTbE+QMtfn8w5WVTrxMWhgNr3YA=";
  };
  version = "10.3.1";

  rdpClient = rustPlatform.buildRustPackage rec {
    pname = "teleport-rdpclient";
    cargoHash = "sha256-Xmabjoq1NXxXemeR06Gg8R/HwdSE+rsxxX645pQ3SuI=";
    inherit version src;

    buildAndTestSubdir = "lib/srv/desktop/rdp/rdpclient";

    buildInputs = [ openssl ]
      ++ lib.optionals stdenv.isDarwin [ CoreFoundation Security ];
    nativeBuildInputs = [ pkg-config ];

    # https://github.com/NixOS/nixpkgs/issues/161570 ,
    # buildRustPackage sets strictDeps = true;
    checkInputs = buildInputs;

    OPENSSL_NO_VENDOR = "1";

    postInstall = ''
      mkdir -p $out/include
      cp ${buildAndTestSubdir}/librdprs.h $out/include/
    '';
  };

  webassets = fetchFromGitHub {
    owner = "gravitational";
    repo = "webassets";
    # Submodule rev from https://github.com/gravitational/teleport/tree/v10.3.1
    rev = "6710dcd0dc19ad101bac3259c463ef940f2ab1f3";
    hash = "sha256-A13FSpgJODmhugAwy4kqiDw4Rihr//DhQX/bjwaeo2A=";
  };
in
buildGoModule rec {
  pname = "teleport";

  inherit src version;
  vendorHash = "sha256-2Zrd3CbZvxns9lNVtwaaor1mi97IhPc+MRJhj3rU760=";

  subPackages = [ "tool/tbot" "tool/tctl" "tool/teleport" "tool/tsh" ];
  tags = [ "libfido2" "webassets_embed" ]
    ++ lib.optional withRdpClient "desktop_access_rdp";

  buildInputs = [ openssl libfido2 ]
    ++ lib.optionals (stdenv.isDarwin && withRdpClient) [ CoreFoundation Security ];
  nativeBuildInputs = [ makeWrapper pkg-config ];

  patches = [
    # https://github.com/NixOS/nixpkgs/issues/120738
    ./tsh.patch
    # https://github.com/NixOS/nixpkgs/issues/132652
    ./test.patch
    ./0001-fix-add-nix-path-to-exec-env.patch
    ./rdpclient.patch
  ];

  # Reduce closure size for client machines
  outputs = [ "out" "client" ];

  preBuild = ''
    mkdir -p build
    echo "making webassets"
    cp -r ${webassets}/* webassets/
    make -j$NIX_BUILD_CORES lib/web/build/webassets
  '' + lib.optionalString withRdpClient ''
    ln -s ${rdpClient}/lib/* lib/
    ln -s ${rdpClient}/include/* lib/srv/desktop/rdp/rdpclient/
  '';

  # Multiple tests fail in the build sandbox
  # due to trying to spawn nixbld's shell (/noshell), etc.
  doCheck = false;

  postInstall = ''
    mkdir -p $client/bin
    mv {$out,$client}/bin/tsh
    # make xdg-open overrideable at runtime
    wrapProgram $client/bin/tsh --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
    ln -s {$client,$out}/bin/tsh
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
