{
  buildah-unwrapped,
  runCommand,
  makeBinaryWrapper,
  symlinkJoin,
  lib,
  stdenv,
  extraPackages ? [ ],
  runc, # Default container runtime
  crun, # Container runtime (default with cgroups v2 for podman/buildah)
  conmon, # Container runtime monitor
  slirp4netns, # User-mode networking for unprivileged namespaces
  fuse-overlayfs, # CoW for images, much faster than default vfs
  util-linuxMinimal, # nsenter
  iptables,
  aardvark-dns,
  netavark,
  passt,
}:

let
  binPath = lib.makeBinPath (
    [
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      runc
      crun
      conmon
      slirp4netns
      fuse-overlayfs
      util-linuxMinimal
      iptables
    ]
    ++ extraPackages
  );

  helpersBin = symlinkJoin {
    name = "${buildah-unwrapped.pname}-helper-binary-wrapper-${buildah-unwrapped.version}";

    # this only works for some binaries, others may need to be added to `binPath` or in the modules
    paths = [
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      aardvark-dns
      netavark
      passt
    ];
  };

in
runCommand buildah-unwrapped.name
  {
    name = "${buildah-unwrapped.pname}-wrapper-${buildah-unwrapped.version}";
    inherit (buildah-unwrapped) pname version passthru;

    preferLocalBuild = true;

    meta = builtins.removeAttrs buildah-unwrapped.meta [ "outputsToInstall" ];

    outputs = [
      "out"
      "man"
    ];

    nativeBuildInputs = [
      makeBinaryWrapper
    ];

  }
  ''
    ln -s ${buildah-unwrapped.man} $man

    mkdir -p $out
    ln -s ${buildah-unwrapped}/share $out/share
    makeWrapper ${buildah-unwrapped}/bin/buildah $out/bin/buildah \
      --set CONTAINERS_HELPER_BINARY_DIR ${helpersBin}/bin \
      --prefix PATH : ${binPath}
  ''
