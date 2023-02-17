{ lib
, stdenv
, fetchurl
, fetchpatch
, libmnl
, pkg-config
, writeScript
}:

stdenv.mkDerivation rec {
  pname = "ethtool";
  version = "6.1";

  src = fetchurl {
    url = "mirror://kernel/software/network/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-xB/Igf+lpAQy0t2CnrRMZKSd7kgucWuqz5Jixk2qj5A=";
  };

  patches = [
    # Patch that fixes build with musl libc
    # NOTE remove on next release, since it is applied in upstream
    (fetchpatch {
      name = "Fix-build-with-musl-libc.patch";
      url = "https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/patch/marvell.c?id=41be533331fc3c6b711dbe532405782d3b8be5d1";
      sha256 = "sha256-CItvt/eeNJkr1sOzaaHZhAnaybDutL9cT2O6XwQll+M=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libmnl
  ];

  passthru = {
    updateScript = writeScript "update-ethtool" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of '<a href="ethtool-VER.tar.xz">...</a>'
      # The page always lists versions newest to oldest. Pick the first one.
      new_version="$(curl -s https://mirrors.edge.kernel.org/pub/software/network/ethtool/ |
          pcregrep -o1 '<a href="ethtool-([0-9.]+)[.]tar[.]xz">' |
          head -n1)"
      update-source-version ${pname} "$new_version"
    '';
  };

  meta = with lib; {
    description = "Utility for controlling network drivers and hardware";
    homepage = "https://www.kernel.org/pub/software/network/ethtool/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}
