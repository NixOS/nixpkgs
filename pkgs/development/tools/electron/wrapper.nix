{ stdenv
, electron-unwrapped
, wrapGAppsHook
, makeWrapper
}:

stdenv.mkDerivation {
  pname = "electron";
  inherit (electron-unwrapped) version;

  nativeBuildInputs = [ wrapGAppsHook makeWrapper ];
  dontWrapGApps = true;

  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper "${electron-unwrapped}/libexec/electron/electron" "$out/bin/electron" \
      "''${gappsWrapperArgs[@]}" \
      --set CHROME_DEVEL_SANDBOX $out/libexec/electron/chrome-sandbox

    ln -s ${electron-unwrapped}/libexec $out/libexec
  '';

  passthru = {
    unwrapped = electron-unwrapped;
    inherit (electron-unwrapped) headers;
  };
  inherit (electron-unwrapped) meta;
}
