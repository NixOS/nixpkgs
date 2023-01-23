{ mkDerivation, lib, fetchurl
, pkg-config, libtool, qmake
, rsync, ssh
}:

with lib;
mkDerivation rec {
  pname = "luckybackup";
  version = "0.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/luckybackup/${version}/source/${pname}-${version}.tar.gz";
    sha256 = "0nwjsk1j33pm8882jbj8h6nxn6n5ab9dxqpqkay65pfbhcjay0g8";
  };

  buildInputs = [ rsync ssh ];

  nativeBuildInputs = [ pkg-config libtool qmake ];

  prePatch = ''
    for File in luckybackup.pro menu/luckybackup-pkexec \
        menu/luckybackup-su.desktop menu/luckybackup.desktop \
        menu/net.luckybackup.su.policy src/functions.cpp \
        src/global.cpp src/scheduleDialog.cpp; do
      substituteInPlace $File --replace "/usr" "$out"
    done
  '';

  meta = {
    description = "A powerful, fast and reliable backup & sync tool";
    longDescription = ''
      luckyBackup is an application for data back-up and synchronization
      powered by the rsync tool.

      It is simple to use, fast (transfers over only changes made and not
      all data), safe (keeps your data safe by checking all declared directories
      before proceeding in any data manipulation), reliable and fully
      customizable.
    '';
    homepage = "https://luckybackup.sourceforge.net/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
