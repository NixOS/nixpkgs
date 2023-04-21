{ lib
}:

with lib;
{
  homepage = "https://tillitis.se/";

  license = with lib.licenses; [
    # LICENSES/README.md: "Unless otherwise noted, the project
    # sources are licensed under the terms and conditions of the
    # 'GNU General Public License v2.0 only'"
    gpl2Only
  ];

  platforms = platforms.all;

  # Because all of the software in this package is cross-compiled
  # there is no need for Hydra to build it on more than one
  # buildPlatform.
  hydraPlatforms = [ "x86_64-linux" ];
}
