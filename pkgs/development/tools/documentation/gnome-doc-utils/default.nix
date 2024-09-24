{ lib, fetchurl, pkg-config, libxml2, libxslt, intltool, gnome
, python3Packages, fetchpatch, bash }:

python3Packages.buildPythonApplication rec {
  pname = "gnome-doc-utils";
  version = "0.20.10";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "19n4x25ndzngaciiyd8dd6s2mf9gv6nv3wv27ggns2smm7zkj1nb";
  };

  patches = [
    # https://bugzilla.redhat.com/show_bug.cgi?id=438638
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/gnome-doc-utils/raw/6b8908abe5af61a952db7174c5d1843708d61f1b/f/gnome-doc-utils-0.14.0-package.patch";
      sha256 = "sha256-V2L2/30NoHY/wj3+dsombxveWRSUJb2YByOKtEgVx/0=";
    })
    # python3 support
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/gnome-doc-utils/raw/6b8908abe5af61a952db7174c5d1843708d61f1b/f/gnome-doc-utils-0.20.10-python3.patch";
      sha256 = "sha256-niH/Yx5H44rsRgkCZS8LWLFB9ZvuInt75zugzoVUhH0=";
    })
  ];

  nativeBuildInputs = [ intltool pkg-config libxslt.dev ];
  buildInputs = [ libxml2 libxslt bash ];
  propagatedBuildInputs = [ python3Packages.libxml2 ];

  configureFlags = [ "--disable-scrollkeeper" ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Collection of documentation utilities for the GNOME project";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-doc-utils";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.all;
  };
}
