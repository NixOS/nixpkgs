{ stdenv, fetchurl, networkmanager, pptp, ppp, intltool, pkgconfig
, libsecret, withGnome ? true, gnome3 }:

let
  pname   = "NetworkManager-pptp";
  version = "1.2.4";
in stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "bd97ce768c34cce6d5b5d43681149a8300bec754397a3f46a0d8d0aea7030c5e";
  };

  buildInputs = [ networkmanager pptp ppp libsecret ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome-keyring
                                        gnome3.networkmanagerapplet ];

  nativeBuildInputs = [ intltool pkgconfig ];

  postPatch = ''
    sed -i -e 's%"\(/usr/sbin\|/usr/pkg/sbin\|/usr/local/sbin\)/[^"]*",%%g' ./src/nm-pptp-service.c

    substituteInPlace ./src/nm-pptp-service.c \
      --replace /sbin/pptp ${pptp}/bin/pptp \
      --replace /sbin/pppd ${ppp}/bin/pppd
  '';

  configureFlags =
    if withGnome then "--with-gnome --with-gtkver=3" else "--without-gnome";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanager-pptp";
    };
  };

  meta = {
    description = "PPtP plugin for NetworkManager";
    inherit (networkmanager.meta) maintainers platforms;
  };
}
