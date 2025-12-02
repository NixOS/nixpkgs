{
  lib,
  mkTclDerivation,
  fetchzip,
  expat,
  gumbo,
  pkg-config,
}:

mkTclDerivation rec {
  pname = "tdom";
  version = "0.9.6";

  src = fetchzip {
    url = "http://tdom.org/downloads/tdom-${version}-src.tgz";
    hash = "sha256-zN855tb9JQUtcB7K1DeAjUBrqhoNH44KbeHwp3qewqw=";
  };

  buildInputs = [
    expat
    gumbo
  ];

  nativeBuildInputs = [ pkg-config ];

  configureFlags = [
    "--enable-html5"
    "--with-expat=${lib.getDev expat}"
  ];

  doInstallCheck = true;
  installCheckTarget = "test";

  meta = {
    description = "XML / DOM / XPath / XSLT / HTML / JSON implementation for Tcl";
    homepage = "http://www.tdom.org";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
