{ stdenv, fetchurl, pkgconfig, curl, openssl, fuse, libxml2, json_c, file }:

stdenv.mkDerivation rec {
  name = "hubicfuse-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = https://github.com/TurboGit/hubicfuse/archive/v2.1.0.tar.gz;
    sha256 = "1mnijcwac6k3f6xknvdrsbmkkizpwbayqkb5l6jic15ymxv1fs7d";
  };

  buildInputs = [ pkgconfig curl openssl fuse libxml2 json_c file ];
  postInstall = ''
    install hubic_token $out/bin
    mkdir -p $out/sbin
    ln -sf $out/bin/hubicfuse $out/sbin/mount.hubicfuse
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/TurboGit/hubicfuse;
    description = "FUSE-based filesystem to access hubic cloud storage";
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
