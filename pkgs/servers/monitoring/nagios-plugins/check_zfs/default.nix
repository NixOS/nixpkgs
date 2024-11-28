{
  fetchFromGitHub,
  lib,
  python3,
  stdenv,
  sudo,
  zfs,
}:

stdenv.mkDerivation rec {
  pname = "check-zfs";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "zlacelle";
    repo = "nagios_check_zfs_linux";
    rev = "refs/tags/${version}";
    sha256 = "gPLCNt6hp4E94s9/PRgsnBN5XXQQ+s2MGcgRFeknXg4=";
  };

  buildInputs = [
    python3
    zfs
  ];

  postPatch = ''
    patchShebangs check_zfs.py
    substituteInPlace check_zfs.py \
      --replace-fail "'/usr/bin/sudo'" "'${sudo}/bin/sudo'" \
      --replace-fail "'/sbin/zpool'" "'${zfs}/bin/zpool'" \
      --replace-fail "'/sbin/zfs'" "'${zfs}/bin/zfs'"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 755 check_zfs.py $out/bin/check_zfs

    runHook postInstall
  '';

  meta = {
    description = "Check the health, capacity, fragmentation, and other things for use with Nagios monitoring";
    homepage = "https://github.com/zlacelle/nagios_check_zfs_linux";
    license = lib.licenses.gpl3Only;
    mainProgram = "check_zfs";
    maintainers = with lib.maintainers; [ mariaa144 ];
  };
}
