{ lib
, stdenv
, fetchFromGitHub
, python3
, zfs
, sudo
}:

stdenv.mkDerivation rec {
  pname = "check_zfs";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "zlacelle";
    repo = "nagios_check_zfs_linux";
    rev = version;
    sha256 = "gPLCNt6hp4E94s9/PRgsnBN5XXQQ+s2MGcgRFeknXg4=";
  };

  buildInputs = [ python3 zfs sudo ];

  postPatch = ''
    patchShebangs check_zfs.py
    substituteInPlace check_zfs.py \
      --replace "'/usr/bin/sudo'" "'${sudo}/bin/sudo'" \
      --replace "'/sbin/zpool'" "'${zfs}/bin/zpool'" \
      --replace "'/sbin/zfs'" "'${zfs}/bin/zfs'"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 755 check_zfs.py $out/bin/check_zfs

    runHook postInstall
  '';

  meta = with lib; {
    description = "Check the health, capacity, fragmentation, and other things for use with Nagios monitoring";
    homepage = "https://github.com/zlacelle/nagios_check_zfs_linux";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mariaa144 ];
  };
}
