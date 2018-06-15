{stdenv, fetchurl, which, autoreconfHook, pkgconfig, curl, vala, python, intltool, fuse, ccnet}:

stdenv.mkDerivation rec {
  version = "6.1.0";
  name = "seafile-shared-${version}";

  src = fetchurl {
    url = "https://github.com/haiwen/seafile/archive/v${version}.tar.gz";
    sha256 = "03zvxk25311xgn383k54qvvpr8xbnl1vxd99fg4ca9yg5rmir1q6";
  };

  nativeBuildInputs = [ pkgconfig which autoreconfHook vala intltool ];
  buildInputs = [ python fuse ];
  propagatedBuildInputs = [ ccnet curl ];

  configureFlags = [
    "--disable-server"
    "--disable-console"
  ];

  postInstall = ''
    # Remove seafile binary
    rm -rf "$out/bin/seafile"
    # Remove cli client binary
    rm -rf "$out/bin/seaf-cli"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/haiwen/seafile;
    description = "Shared components of Seafile: seafile-daemon, libseafile, libseafile python bindings, manuals, and icons";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
