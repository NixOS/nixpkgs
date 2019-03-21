{ stdenv, fetchFromGitHub, python3, pass }:

stdenv.mkDerivation rec {
  name = "passff-host-${version}";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "passff";
    repo = "passff-host";
    rev = version;
    sha256 = "1zks34rg9i8vphjrj1h80y5rijadx33z911qxa7pslf7ahmjqdv3";
  };

  buildInputs = [ python3 ];

  patchPhase = ''
    sed -i 's#COMMAND      = "pass"#COMMAND = "${pass}/bin/pass"#' src/passff.py
  '';

  preBuild = "cd src";
  postBuild = "cd ..";

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
