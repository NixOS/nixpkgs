{ lib, fetchurl, pkg-config, libxml2Python, libxslt, intltool, gnome
, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "gnome-doc-utils";
  version = "0.20.10";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "19n4x25ndzngaciiyd8dd6s2mf9gv6nv3wv27ggns2smm7zkj1nb";
  };

  nativeBuildInputs = [ intltool pkg-config libxslt.dev ];
  buildInputs = [ libxslt ];

  configureFlags = [ "--disable-scrollkeeper" ];

  preBuild = ''
    substituteInPlace xml2po/xml2po/Makefile --replace '-e "s+^#!.*python.*+#!$(PYTHON)+"' '-e "s\"^#!.*python.*\"#!$(PYTHON)\""'
  '';

  propagatedBuildInputs = [ libxml2Python ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  postFixup = ''
    # Do not propagate Python
    rm $out/nix-support/propagated-build-inputs
  '';

  meta = with lib; {
    description = "Collection of documentation utilities for the GNOME project";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-doc-utils";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.all;
  };
}
