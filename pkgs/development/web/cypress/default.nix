{stdenv, fetchurl, autoPatchelfHook, xorg, gtk2, gnome2, nss, alsaLib, udev, unzip}:

stdenv.mkDerivation rec{
  version = "3.2.0";
  name = "cypress-${version}";
  src = fetchurl {
    url = "https://download.cypress.io/desktop/${version}?platform=linux64";
    sha256 = "0vz1dv7l10kzaqbsgsbvma531n5pi3vfdnyqpwia5b0m31j6wj0y";
  };

  # don't remove runtime deps
  dontPatchELF = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = with xorg; [
    libXScrnSaver libXdamage libXtst
  ] ++ [
    nss gtk2 alsaLib gnome2.GConf unzip
  ];

  runtimeDependencies = [ udev.lib ];

  unpackCmd = ''
    unzip $curSrc
  '';

  installPhase = ''
    mkdir -p $out/bin $out/opt/cypress
    cp -r * $out/opt/cypress/
    # Let's create the file binary_state ourselves to make the npm package happy on initial verification.
    echo '{"verified": true}' > $out/opt/cypress/binary_state.json
    ln -s $out/opt/cypress/Cypress $out/bin/Cypress
  '';

  meta = with stdenv.lib; {
    description = "Fast, easy and reliable testing for anything that runs in a browser.";
    homepage = https://www.cypress.io;
    license = licenses.mit;
    platforms = ["x86_64-linux"];
    maintainers = with maintainers; [ erosennin tweber acyuta108 ];
  };
}
