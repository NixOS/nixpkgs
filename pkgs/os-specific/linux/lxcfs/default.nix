{
  lib,
  stdenv,
  fetchFromGitHub,
  fuse3,
  help2man,
  makeWrapper,
  meson,
  ninja,
  nixosTests,
  pkg-config,
  python3,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "lxcfs";
  version = "5.0.4";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "lxcfs";
    rev = "lxcfs-${version}";
    sha256 = "sha256-vusxbFV7cnQVBOOo7E+fSyaE63f5QiE2xZhYavc8jJU=";
  };

  patches = [
    # skip RPM spec generation
    ./no-spec.patch

    # skip installing systemd files
    ./skip-init.patch

    # fix pidfd checks and include
    ./pidfd.patch
  ];


  nativeBuildInputs = [
    meson
    help2man
    makeWrapper
    ninja
    (python3.withPackages (p: [ p.jinja2 ]))
    pkg-config
  ];
  buildInputs = [ fuse3 ];

  preConfigure = ''
    patchShebangs tools/
  '';

  postInstall = ''
    # `mount` hook requires access to the `mount` command from `util-linux`:
    wrapProgram "$out/share/lxcfs/lxc.mount.hook" --prefix PATH : "${util-linux}/bin"
  '';

  postFixup = ''
    # liblxcfs.so is reloaded with dlopen()
    patchelf --set-rpath "$(patchelf --print-rpath "$out/bin/lxcfs"):$out/lib" "$out/bin/lxcfs"
  '';

  passthru.tests = {
    incus-container = nixosTests.incus.container;
  };

  meta = {
    description = "FUSE filesystem for LXC";
    homepage = "https://linuxcontainers.org/lxcfs";
    changelog = "https://linuxcontainers.org/lxcfs/news/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.lxc.members;
  };
}
