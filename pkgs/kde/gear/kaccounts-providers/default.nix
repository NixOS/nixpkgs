{
  lib,
  mkKdeDerivation,
  intltool,
  qtdeclarative,
  qtwebengine,
  googleClientId ? null,
  googleClientSecret ? null,
  withGoogleDriveScope ? false,
  withYoutubeScope ? true,
}:
let
  scopes =
    lib.optional withYoutubeScope "'https://www.googleapis.com/auth/youtube.upload'"
    ++ lib.optional withGoogleDriveScope "'https://www.googleapis.com/auth/drive'";
  scopeLine = lib.concatStringsSep ",\n              " scopes;
in
mkKdeDerivation {
  pname = "kaccounts-providers";

  extraNativeBuildInputs = [ intltool ];
  extraBuildInputs = [
    qtdeclarative
    qtwebengine
  ];

  postPatch =
    lib.optionalString (googleClientId != null) ''
      sed -i 's|<setting name="ClientId">[^<]*</setting>|<setting name="ClientId">${googleClientId}</setting>|' \
        providers/google.provider.in
    ''
    + lib.optionalString (googleClientSecret != null) ''
      sed -i 's|<setting name="ClientSecret">[^<]*</setting>|<setting name="ClientSecret">${googleClientSecret}</setting>|' \
        providers/google.provider.in
    ''
    + ''
      substituteInPlace providers/google.provider.in \
        --replace-fail "'https://www.googleapis.com/auth/youtube.upload'" \
                       ${lib.escapeShellArg scopeLine}
    '';
}
