# This package provides the QHYCCD SDK, which is intended for non-commercial use only.
{
  lib,
  stdenv,
  fxload,
  fetchurl,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "qhyccd_sdk";
  version = "23.09.06";
  linux64Sha256 = "17ayxxf5wk2k14jyry3c5m5mwnyh9r0ykyh8iaxdlsk9dzjw0chp";
  arm64Sha256 = "1ag70zpzqp6dp0rvz974vsnfyll7jvwq69s1hai3v2chvywllhs5";

  dontConfigure = true;
  dontPatch = true;
  dontPatchELF = true;

  strippedVersion = builtins.replaceStrings ["."] [""] version;

  archSuffix =
    if stdenv.system == "aarch64-linux"
    then "Arm64"
    else "linux64";

  archSha256 =
    if stdenv.system == "aarch64-linux"
    then arm64Sha256
    else linux64Sha256;

  src = fetchurl {
    url = "https://www.qhyccd.com/file/repository/publish/SDK/${strippedVersion}/sdk_${archSuffix}_${version}.tgz";
    sha256 = archSha256;
  };

  buildInput = [makeWrapper];
  # builder = ''./install.sh'';

  buildPhase = ''
    chmod +x ./install.sh
    chmod +x ./distclean.sh
    chmod +x ./uninstall.sh

    mkdir -p $out/sbin

    substituteInPlace ./install.sh ./distclean.sh ./uninstall.sh \
      --replace /lib/udev $out/lib/udev \
      --replace /etc/udev $out/etc/udev \
      --replace "cp -a sbin/fxload" "# cp -a /sbin/fxload" \
      --replace /usr/local $out/usr/local \
      --replace /lib/firmware $out/lib/firmware \
      --replace /usr/share/usb $out/usr/share/usb \
      --replace ldconfig '# ldconfig'

      # udev rules
      #option 1: services.udev.packages = [ pkgs.qhyccd_sdk ];

      echo -################
      cat ./install.sh # grep sbin
      echo -################
  '';

  installPhase = ''
    ln -s ${fxload}/bin/fxload $out/sbin/fxload
      echo -################
    source ./install.sh
    echo ou2
    ls -la $out
    echo -################
  '';

  uninstallPhase = ''
    cd sdk_${archSuffix}_${version}
    sudo ./uninstall.sh
  '';

  meta = with lib; {
    homepage = "https://www.qhyccd.com/html/prepub/log_en.html";
    description = "A software development kit for interfacing with QHYCCD astronomy cameras, including libraries and sample code. Non-commercial use only.";
    platforms = platforms.linux;
    license = licenses.unfree;
    requireAllowUnfree = true;
    maintainers = with maintainers; [realsnick];
  };
}
