{
  fetchurl,
  lib,
  darwin,
}:
darwin.installBinaryPackage rec {
  pname = "wire-desktop";
  version = "3.40.5285";
  src = fetchurl {
    url = "https://github.com/wireapp/wire-desktop/releases/download/macos%2F${version}/Wire.pkg";
    hash = "sha256-pcWB3irdPyDj55dWmNyc+oThVGgHtIu//EAk1k/56is=";
  };

  appName = "Wire.app";

  meta = with lib; {
    description = "Modern, secure messenger for everyone";
    longDescription = ''
      Wire Personal is a secure, privacy-friendly messenger. It combines useful
      and fun features, audited security, and a beautiful, distinct user
      interface.  It does not require a phone number to register and chat.

        * End-to-end encrypted chats, calls, and files
        * Crystal clear voice and video calling
        * File and screen sharing
        * Timed messages and chats
        * Synced across your phone, desktop and tablet
    '';
    homepage = "https://wire.com/";
    downloadPage = "https://wire.com/download/";
    license = lib.licenses.gpl3Plus;
    maintainers = with maintainers; [ dwt ];
  };
}
