{ lib, stdenv, fetchurl, libxslt, docbook_xsl, libcap }:

stdenv.mkDerivation rec {
  pname = "bubblewrap";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/containers/bubblewrap/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-ETk88gWPIuamxunMo8hf9MQjmAbLKP7mV8YqVE3zVpM=";
  };

  nativeBuildInputs = [ libxslt docbook_xsl ];
  buildInputs = [ libcap ];

  meta = with lib; {
    description = "Unprivileged sandboxing tool";
    homepage = "https://github.com/containers/bubblewrap";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
