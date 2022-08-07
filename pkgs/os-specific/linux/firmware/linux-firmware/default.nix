{ stdenvNoCC, fetchzip, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "linux-firmware";
  version = "20220708";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-${version}.tar.gz";
    sha256 = "sha256-jsmbBxQ4RHBySBq2lks5tJ6YTwwlkvVe2Xc0CDJY8IE=";
  };

  installFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-FNYZMJnqR2waODUXisch3ObdEjwQN94QSiBE2dDW4sk=";

  meta = with lib; {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    priority = 6; # give precedence to kernel firmware
  };

  passthru = { inherit version; };
}
