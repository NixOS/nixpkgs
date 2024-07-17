{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  installShellFiles,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "swapspace";
  version = "1.18";

  src = fetchFromGitHub {
    owner = "Tookmund";
    repo = "Swapspace";
    rev = "v${version}";
    sha256 = "sha256-tzsw10cpu5hldkm0psWcFnWToWQejout/oGHJais6yw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    installShellFiles
  ];

  postPatch = ''
    substituteInPlace 'swapspace.service' \
      --replace '/usr/local/sbin/' "$out/bin/"
    substituteInPlace 'src/support.c' \
      --replace '/sbin/swapon' '${lib.getBin util-linux}/bin/swapon' \
      --replace '/sbin/swapoff' '${lib.getBin util-linux}/bin/swapoff'
    substituteInPlace 'src/swaps.c' \
      --replace 'mkswap' '${lib.getBin util-linux}/bin/mkswap'

    # Don't create empty directory $out/var/lib/swapspace
    substituteInPlace 'Makefile.am' \
      --replace 'install-data-local:' 'do-not-execute:'
  '';

  postInstall = ''
    installManPage doc/swapspace.8
    install --mode=444 -D 'swapspace.service' "$out/etc/systemd/system/swapspace.service"
  '';

  meta = with lib; {
    description = "Dynamic swap manager for Linux";
    homepage = "https://github.com/Tookmund/Swapspace";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Luflosi ];
    mainProgram = "swapspace";
  };
}
