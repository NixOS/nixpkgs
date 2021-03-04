{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, bzip2
, libusb1
, libzip
, openssl
}:

stdenv.mkDerivation rec {
  pname = "nxpmicro-mfgtools";
  version = "1.4.72";

  src = fetchFromGitHub {
    owner = "NXPmicro";
    repo = "mfgtools";
    rev = "uuu_${version}";
    sha256 = "1s3wlz4yb2p8by5p66vr0z72n84mxkrmda63x9yr6pinqinsyrvv";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ bzip2 libusb1 libzip openssl ];

  preConfigure = "echo ${version} > .tarball-version";

  postInstall = ''
    # rules printed by the following invocation are static,
    # they come from hardcoded configs in libuuu/config.cpp:48
    $out/bin/uuu -udev > udev-rules 2>stderr.txt
    rules_file="$(cat stderr.txt|grep '1: put above udev run into'|sed 's|^.*/||')"
    install -D udev-rules "$out/lib/udev/rules.d/$rules_file"
  '';

  meta = with lib; {
    description = "Freescale/NXP I.MX chip image deploy tools";
    longDescription = ''
      UUU (Universal Update Utility) is a command line tool, evolved out of
      MFGTools (aka MFGTools v3).

      One of the main purposes is to upload images to I.MX SoC's using at least
      their boot ROM.

      With time, the need for an update utility portable to Linux and Windows
      increased. UUU has the same usage on both Windows and Linux. It means the same
      script works on both OS.
    '';
    homepage = "https://github.com/NXPmicro/mfgtools";
    license = licenses.bsd3;
    maintainers = [ maintainers.bmilanov ];
    platforms = platforms.all;
  };
}
