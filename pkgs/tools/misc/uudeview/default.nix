{ lib
, stdenv
, fetchurl
, fetchpatch
, tcl
, tk
}:

stdenv.mkDerivation rec {
  pname = "uudeview";
  version = "0.5.20";

  src = fetchurl {
    url = "http://www.fpx.de/fp/Software/UUDeview/download/${pname}-${version}.tar.gz";
    sha256 = "0dg4v888fxhmf51vxq1z1gd57fslsidn15jf42pj4817vw6m36p4";
  };

  buildInputs = [ tcl tk ];

  configureFlags = [ "--enable-tk=${tk.dev}" "--enable-tcl=${tcl}" ];

  patches = [
    # https://wiki.tcl.tk/3577
    ./matherr.patch
    # format hardening
    (fetchpatch {
      url = "https://raw.githubusercontent.com/OpenMandrivaAssociation/uudeview/master/uudeview-0.5.20-fix-str-fmt.patch";
      sha256 = "1biipck60mhpd0j6jwizaisvqa8alisw1dpfqm6zf7ic5b93hmfw";
      extraPrefix = "";
    })
  ];

  postPatch = ''
    substituteInPlace tcl/xdeview --replace "exec uuwish" "exec $out/bin/uuwish"
  '';

  meta = {
    description = "The Nice and Friendly Decoder";
    homepage = "http://www.fpx.de/fp/Software/UUDeview/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ woffs ];
    platforms = lib.platforms.linux;
  };
}
