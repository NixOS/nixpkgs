{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, bzip2
, installShellFiles
, libusb1
, libzip
, openssl
, zstd
}:

stdenv.mkDerivation rec {
  pname = "nxpmicro-mfgtools";
  version = "1.5.125";

  src = fetchFromGitHub {
    owner = "nxp-imx";
    repo = "mfgtools";
    rev = "uuu_${version}";
    sha256 = "sha256-f9Nt303xXZzLSu3GtOEpyaL91WVFUmKO7mxi8UNX3go=";
  };

  patches = [
    # Backport upstream fix for gcc-13 support:
    #   https://github.com/nxp-imx/mfgtools/pull/360
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/nxp-imx/mfgtools/commit/24fd043225903247f71ac10666d820277c0b10b1.patch";
      hash = "sha256-P7n6+Tiz10GIQ7QOd/qQ3BI7Wo5/66b0EwjFSpOUSJg=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config installShellFiles ];

  buildInputs = [ bzip2 libusb1 libzip openssl zstd ];

  preConfigure = "echo ${version} > .tarball-version";

  postInstall = ''
    # rules printed by the following invocation are static,
    # they come from hardcoded configs in libuuu/config.cpp:48
    $out/bin/uuu -udev > udev-rules 2>stderr.txt
    rules_file="$(cat stderr.txt|grep '1: put above udev run into'|sed 's|^.*/||')"
    install -D udev-rules "$out/lib/udev/rules.d/$rules_file"
    installShellCompletion --cmd uuu \
      --bash ../snap/local/bash-completion/universal-update-utility
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
    maintainers = with maintainers; [ bmilanov jraygauthier ];
    mainProgram = "uuu";
    platforms = platforms.all;
  };
}
