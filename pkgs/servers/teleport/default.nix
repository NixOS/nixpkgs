{ lib
, buildGoModule
, rustPlatform
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, CoreFoundation
, AppKit
, libfido2
, nodejs
, openssl
, pkg-config
, Security
, stdenv
, xdg-utils
, yarn
, yarn2nix-moretea
, nixosTests

, withRdpClient ? true
}:
let
  # This repo has a private submodule "e" which fetchgit cannot handle without failing.
  src = fetchFromGitHub {
    owner = "gravitational";
    repo = "teleport";
    rev = "v${version}";
    hash = "sha256-LxKrzVQ8VX3f0Ow37ql6l9nbu1Ujw8KmT4HLhF28Eyk=";
  };
  version = "10.3.15";

  rdpClient = rustPlatform.buildRustPackage rec {
    pname = "teleport-rdpclient";
    cargoHash = "sha256-lllNz5esSJ7dPSyACNOXazc11JJtfW9vWI5QcFaQtLs=";
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

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-W3F8cllq9VTkZtBDpZLk3DKhNxj1NAxARa6J++B4WeI=";
  };

  webassets = stdenv.mkDerivation {
    pname = "teleport-webassets";
    inherit src version;

    nativeBuildInputs = [
      nodejs
      yarn
      yarn2nix-moretea.fixup_yarn_lock
    ];

    configurePhase = ''
      export HOME=$(mktemp -d)
    '';

    buildPhase = ''
      yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
      fixup_yarn_lock yarn.lock
      yarn install --offline \
        --frozen-lockfile \
        --ignore-engines --ignore-scripts
      patchShebangs .
      yarn build-ui-oss
    '';

    installPhase = ''
      mkdir -p $out
      cp -R webassets/. $out
    '';
  };
in
buildGoModule rec {
  pname = "teleport";

  inherit src version;
  vendorHash = "sha256-7fzgtbqzn1sHdMwTggYCMX0VaYucDT6u5c1Ru0nPtvE=";
  proxyVendor = true;

  subPackages = [ "tool/tbot" "tool/tctl" "tool/teleport" "tool/tsh" ];
  tags = [ "libfido2" "webassets_embed" ]
    ++ lib.optional withRdpClient "desktop_access_rdp";

  buildInputs = [ openssl libfido2 ]
    ++ lib.optionals (stdenv.isDarwin && withRdpClient) [ CoreFoundation Security AppKit ];
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
    cp -r ${webassets} webassets
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
