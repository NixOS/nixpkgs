{ lib, stdenv, fetchFromGitHub, makeWrapper, perl, perlPackages, dmidecode, edid-decode
, smartmontools , xz, curl, hwinfo, pciutils, usbutils, iproute2, util-linux
}:
let
    prefixPath = programs:
      "--prefix PATH ':' '${lib.makeBinPath programs}'";
    programs = [ dmidecode edid-decode smartmontools xz curl hwinfo pciutils usbutils iproute2 util-linux ];
in stdenv.mkDerivation rec {
  pname = "hw-probe";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "linuxhw";
    repo = "hw-probe";
    rev = version;
    sha256 = "028wnhrbn10lfxwmcpzdbz67ygldimv7z1k1bm64ggclykvg5aim";
  };

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ perl perlPackages.DigestSHA1 ];
  buildInputs = [ perl perlPackages.DigestSHA1 ];

  installPhase = ''
    make install "prefix=$out"
    wrapProgram $out/bin/hw-probe \
      ${prefixPath programs}
  '';

  meta = with lib; {
    description = "A tool to probe for hardware and upload result to the Linux Hardware Database";
    longDescription = ''
      Hardware Probe Tool is a tool to probe for hardware, check it's
      operability and find drivers. The probes are uploaded to the Linux
      hardware database. See https://linux-hardware.org for more information.
    '';
    homepage = "https://github.com/linuxhw/hw-probe/";
    changelog = "https://github.com/linuxhw/hwprobe/blob/${version}/NEWS.md";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ winny ];
  };
}
