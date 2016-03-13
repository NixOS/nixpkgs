{ stdenv, fetchurl, pkgconfig, intltool, openssl, curl, libnotify, gstreamer,
  gst_plugins_base, gst_plugins_good, gnome3, makeWrapper, aria2 ? null }:

stdenv.mkDerivation rec {
  name = "uget-${version}";
  version = "2.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/urlget/${name}.tar.gz";
    sha256 = "0cqz8cd8dyciam07w6ipgzj52zhf9q0zvg6ag6wz481sxkpdnfh3";
  };

  nativeBuildInputs = [ pkgconfig intltool makeWrapper ];
  
  buildInputs = [
    openssl curl libnotify gstreamer gst_plugins_base gst_plugins_good
    gnome3.gtk gnome3.dconf
  ]
  ++ (stdenv.lib.optional (aria2 != null) aria2);

  enableParallelBuilding = true;
  
  preFixup = ''
    wrapProgram $out/bin/uget-gtk \
      ${stdenv.lib.optionalString (aria2 != null) ''--suffix PATH : "${aria2}/bin"''} \
      --prefix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH" \
      --prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH" \
      --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules"
  '';

  meta = with stdenv.lib; {
    description = "Download manager using gtk+ and libcurl";
    longDescription = ''
      uGet is a VERY Powerful download manager application with a large
      inventory of features but is still very light-weight and low on
      resources, so don't let the impressive list of features scare you into
      thinking that it "might be too powerful" because remember power is good
      and lightweight power is uGet!
    '';
    license = licenses.lgpl21;
    homepage = http://www.ugetdm.com;
    maintainers = with maintainers; [ romildo ];
    platforms = platforms.unix;
  };
}
