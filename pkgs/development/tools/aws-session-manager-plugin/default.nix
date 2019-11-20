{ stdenv, fetchurl, dpkg }:
stdenv.mkDerivation rec {
  name = "session-manager-plugin";
  version = "1.1.50.0";
  src = fetchurl {
    url = "https://s3.amazonaws.com/session-manager-downloads/plugin/${version}/ubuntu_64bit/session-manager-plugin.deb";
    sha256 = "073kch3x9k4zwd01k80q8pyv4rc4s17x9pv4z2hsqdsh2wznnacc";
  };

  nativeBuildInputs = [ dpkg ];
  sourceRoot = ".";
  unpackCmd = "dpkg-deb -x $src .";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
      mkdir -p $out/bin
      cp -R usr/local/sessionmanagerplugin/bin $out/
  '';
  preFixup = ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $out/bin/session-manager-plugin
  '';

  meta = with stdenv.lib; {
    homepage = "https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html";
    description = "The AWS CLI session manager plugin";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ socksy ];
  };
}
