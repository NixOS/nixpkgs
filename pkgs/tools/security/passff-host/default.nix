{ stdenv, fetchFromGitHub, python3, pass }:

stdenv.mkDerivation rec {
  name = "passff-host-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "passff";
    repo = "passff-host";
    rev = version;
    sha256 = "0ydfwvhgnw5c3ydx2gn5d7ys9g7cxlck57vfddpv6ix890v21451";
  };

  buildInputs = [ python3 ];

  patchPhase = ''
    sed -i 's#COMMAND = "pass"#COMMAND = "${pass}/bin/pass"#' src/passff.py
  '';

  installPhase = ''
    install -D bin/testing/passff.py $out/share/passff-host/passff.py
    cp bin/testing/passff.json $out/share/passff-host/passff.json
    substituteInPlace $out/share/passff-host/passff.json \
      --replace PLACEHOLDER $out/share/passff-host/passff.py
  '';

  meta = with stdenv.lib; {
    description = "Host app for the WebExtension PassFF";
    homepage = https://github.com/passff/passff-host;
    license = licenses.gpl2;
    maintainers = with maintainers; [ nadrieril ];
  };
}
