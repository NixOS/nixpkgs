{ lib
, stdenv
, fetchurl
, libmnl
, pkg-config
, writeScript
}:

stdenv.mkDerivation rec {
  pname = "ethtool";
  version = "5.18";

  src = fetchurl {
    url = "mirror://kernel/software/network/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-lXey/7znELZZ+yOVmOySvO0cpADKDxKGdiv6ROR4QnA=";
  };

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
