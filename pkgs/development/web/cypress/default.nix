{ stdenv, fetchzip, autoPatchelfHook, xorg, gtk2, gnome2, gtk3, nss, alsaLib, udev, unzip, wrapGAppsHook }:

stdenv.mkDerivation rec{
  pname = "cypress";
  version = "3.4.0";

  src = fetchzip {
    url = "https://cdn.cypress.io/desktop/${version}/linux-x64/cypress.zip";
    sha256 = "1j59az9j37a61ryvh975bc7bj43qi3dq0871fyambh1j2mby00qn";
  };

  # don't remove runtime deps
  dontPatchELF = true;

  nativeBuildInputs = [ autoPatchelfHook wrapGAppsHook ];

  buildInputs = with xorg; [
    libXScrnSaver libXdamage libXtst
  ] ++ [
    nss gtk2 alsaLib gnome2.GConf gtk3 unzip
  ];

  runtimeDependencies = [ udev.lib ];

  installPhase = ''
    mkdir -p $out/bin $out/opt/cypress
    cp -vr * $out/opt/cypress/
    # Let's create the file binary_state ourselves to make the npm package happy on initial verification.
    echo '{"verified": true}' > $out/opt/cypress/binary_state.json
    ln -s $out/opt/cypress/Cypress $out/bin/Cypress
  '';

  meta = with stdenv.lib; {
    description = "Fast, easy and reliable testing for anything that runs in a browser";
    homepage = "https://www.cypress.io";
    license = licenses.mit;
    platforms = ["x86_64-linux"];
    maintainers = with maintainers; [ tweber mmahut ];
  };
}
