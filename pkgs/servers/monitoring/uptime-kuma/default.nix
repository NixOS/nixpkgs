{ pkgs, lib, stdenv, fetchFromGitHub, fetchzip, nixosTests, iputils, nodejs, makeWrapper }:
let
  deps = import ./composition.nix { inherit pkgs; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "uptime-kuma";
  version = "1.19.6";

  src = fetchFromGitHub {
    owner = "louislam";
    repo = "uptime-kuma";
    rev = finalAttrs.version;
    sha256 = "sha256-Hk0me4VPP8vKp4IhzQKjjhM2BWLGSHnN7JiDJu2WlE8=";
  };

  uiSha256 = "sha256-oeXklGxAPsUoLRT6DAVRgWm0kvKbLFW4IBc0Rh3j5V4=";

  patches = [
    # Fixes the permissions of the database being not set correctly
    # See https://github.com/louislam/uptime-kuma/pull/2119
    ./fix-database-permissions.patch
  ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/
    cp -r server $out/share/
    cp -r db $out/share/
    cp -r src $out/share/
    cp package.json $out/share/
    ln -s ${deps.package}/lib/node_modules/uptime-kuma/node_modules/ $out/share/
    ln -s ${finalAttrs.passthru.ui} $out/share/dist
  '';

  postFixup = ''
    makeWrapper ${nodejs}/bin/node $out/bin/uptime-kuma-server \
      --add-flags $out/share/server/server.js \
      --chdir $out/share/
  '';

  passthru = {
    tests.uptime-kuma = nixosTests.uptime-kuma;

    updateScript = ./update.sh;

    ui = fetchzip {
      name = "uptime-kuma-dist-${finalAttrs.version}";
      url = "https://github.com/louislam/uptime-kuma/releases/download/${finalAttrs.version}/dist.tar.gz";
      sha256 = finalAttrs.uiSha256;
    };
  };

  meta = with lib; {
    description = "A fancy self-hosted monitoring tool";
    homepage = "https://github.com/louislam/uptime-kuma";
    license = licenses.mit;
    maintainers = with maintainers; [ julienmalka ];
  };
})

