{
  lib,
  stdenv,
  fetchFromGitHub,
  docbook2x,
  libapparmor,
  libcap,
  libseccomp,
  libselinux,
  meson,
  ninja,
  nix-update-script,
  nixosTests,
  openssl,
  pam,
  pkg-config,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "lxc";
  version = "5.0.3";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "lxc";
    rev = "refs/tags/lxc-${version}";
    hash = "sha256-lnLmLgWXt3pI2S+4OeHRlPP5gui7S7ZXXClFt+n/8sY=";
  };

  nativeBuildInputs = [
    docbook2x
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libapparmor
    libcap
    libseccomp
    libselinux
    openssl
    pam
    systemd
  ];

  patches = [ ./add-meson-options.patch ];

  mesonFlags = [
    "-Dinstall-init-files=false"
    "-Dinstall-state-dirs=false"
    "-Dspecfile=false"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru = {
    tests.incus = nixosTests.incus.container;
    updateScript = nix-update-script {
      extraArgs = [
        "-vr"
        "lxc-(.*)"
      ];
    };
  };

  meta = {
    homepage = "https://linuxcontainers.org/";
    description = "Userspace tools for Linux Containers, a lightweight virtualization system";
    license = lib.licenses.gpl2;

    longDescription = ''
      LXC containers are often considered as something in the middle between a chroot and a
      full fledged virtual machine. The goal of LXC is to create an environment as close as
      possible to a standard Linux installation but without the need for a separate kernel.
    '';

    platforms = lib.platforms.linux;
    maintainers = lib.teams.lxc.members;
  };
}
