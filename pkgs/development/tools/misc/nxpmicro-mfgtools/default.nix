{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, bzip2
, installShellFiles
, libusb1
, libzip
, openssl
}:

stdenv.mkDerivation rec {
  pname = "nxpmicro-mfgtools";
  version = "1.4.165";

  src = fetchFromGitHub {
    owner = "NXPmicro";
    repo = "mfgtools";
    rev = "uuu_${version}";
    sha256 = "0k309lp27d4k6x4qq0badbk8i47xsc6f3fffz73650iyfs4hcniw";
  };

  nativeBuildInputs = [ cmake pkg-config installShellFiles ];

  buildInputs = [ bzip2 libusb1 libzip openssl ];

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
