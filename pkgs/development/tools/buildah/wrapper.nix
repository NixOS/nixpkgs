{ buildah-unwrapped
, runCommand
, makeWrapper
, lib
, stdenv
, extraPackages ? []
, buildah
, runc # Default container runtime
, crun # Container runtime (default with cgroups v2 for podman/buildah)
, conmon # Container runtime monitor
, slirp4netns # User-mode networking for unprivileged namespaces
, fuse-overlayfs # CoW for images, much faster than default vfs
, util-linux # nsenter
, iptables
}:

let
  buildah = buildah-unwrapped;

  preferLocalBuild = true;

  binPath = lib.makeBinPath ([
  ] ++ lib.optionals stdenv.isLinux [
    runc
    crun
    conmon
    slirp4netns
    fuse-overlayfs
    util-linux
    iptables
  ] ++ extraPackages);

in runCommand buildah.name {
  name = "${buildah.pname}-wrapper-${buildah.version}";
  inherit (buildah) pname version;

  meta = builtins.removeAttrs buildah.meta [ "outputsToInstall" ];

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

} ''
  ln -s ${buildah.man} $man

  mkdir -p $out/bin
  ln -s ${buildah-unwrapped}/share $out/share
  makeWrapper ${buildah-unwrapped}/bin/buildah $out/bin/buildah \
    --prefix PATH : ${binPath}
''
