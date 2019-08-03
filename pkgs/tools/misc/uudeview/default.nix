{ stdenv, fetchurl, tcl, tk }:

stdenv.mkDerivation rec {
  name = "uudeview-0.5.20";
  src = fetchurl {
    url = "http://www.fpx.de/fp/Software/UUDeview/download/${name}.tar.gz";
    sha256 = "0dg4v888fxhmf51vxq1z1gd57fslsidn15jf42pj4817vw6m36p4";
  };

  buildInputs = [ tcl tk ];
  hardeningDisable = [ "format" ];
  configureFlags = [ "--enable-tk=${tk.dev}" "--enable-tcl=${tcl}" ];

  # https://wiki.tcl.tk/3577
  patches = [ ./matherr.patch ];
  postPatch = ''
    substituteInPlace tcl/xdeview --replace "exec uuwish" "exec $out/bin/uuwish"
  '';

  meta = {
    description = "The Nice and Friendly Decoder";
    homepage = http://www.fpx.de/fp/Software/UUDeview/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ woffs ];
    platforms = stdenv.lib.platforms.linux;
  };
}
