{ lib, buildGoModule, fetchFromGitHub, makeWrapper, xdg-utils }:
let
  webassets = fetchFromGitHub {
    owner = "gravitational";
    repo = "webassets";
    rev = "240464d54ac498281592eb0b30c871dc3c7ce09b";
    sha256 = "sha256-8gt8x2fNh8mA1KCop5dEZmpBWBu7HsrTY5zVUlmKDgs=";
  };
in
buildGoModule rec {
  pname = "teleport";
  version = "8.0.6";

  # This repo has a private submodule "e" which fetchgit cannot handle without failing.
  src = fetchFromGitHub {
    owner = "gravitational";
    repo = "teleport";
    rev = "v${version}";
    sha256 = "sha256-02Wsj2V7RNjKlkgAqj7IqyRGCxml8pw5h0vflqcGAB8=";
  };

  vendorSha256 = null;

  subPackages = [ "tool/tctl" "tool/teleport" "tool/tsh" ];
  tags = [ "webassets_embed" ];

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
  '';

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

  meta = with lib; {
    description = "A SSH CA management suite";
    homepage = "https://goteleport.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ sigma tomberek freezeboy ];
    platforms = platforms.unix;
  };
}
