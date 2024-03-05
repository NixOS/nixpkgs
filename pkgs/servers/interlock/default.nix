{ lib
, buildGoModule
, fetchFromGitHub
, coreutils
, cryptsetup
, mount
, systemd
, umount
}:

buildGoModule rec {
  pname = "interlock";
  version = "2020.03.05";

  src = fetchFromGitHub {
    owner = "usbarmory";
    repo = "interlock";
    rev = "v${version}";
    sha256 = "sha256-YXa4vErt3YnomTKAXCv8yUVhcc0ST47n9waW5E8QZzY=";
  };

  vendorHash = "sha256-OL6I95IpyTIc8wCwD9nWxVUTrmZH6COhsd/YwNTyvN0=";

  ldflags = [ "-s" "-w" ];

  postPatch = ''
    grep -lr '/s\?bin/' | xargs sed -i \
      -e 's|/bin/mount|${mount}/bin/mount|' \
      -e 's|/bin/umount|${umount}/bin/umount|' \
      -e 's|/bin/cp|${coreutils}/bin/cp|' \
      -e 's|/bin/mv|${coreutils}/bin/mv|' \
      -e 's|/bin/chown|${coreutils}/bin/chown|' \
      -e 's|/bin/date|${coreutils}/bin/date|' \
      -e 's|/sbin/poweroff|${systemd}/sbin/poweroff|' \
      -e 's|/usr/bin/sudo|/run/wrappers/bin/sudo|' \
      -e 's|/sbin/cryptsetup|${cryptsetup}/bin/cryptsetup|'
  '';

  postInstall = ''
    mkdir -p $out/share
    cp -R $src/static $out/share
  '';

  # Tests are broken due to an error during key generation.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/usbarmory/interlock";
    description = "File encryption tool and an HSM frontend";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
