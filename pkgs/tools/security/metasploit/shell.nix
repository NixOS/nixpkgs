{
  pkgs ? import ../../../.. { },
}:
pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.pkg-config
    pkgs.libffi # libffi as native input
  ];
  buildInputs = with pkgs; [
    bundix
    git
    libiconv
    libpcap
    libxml2
    libxslt
    postgresql
    ruby.devEnv
    sqlite
  ];
  # Ensure that pkg-config finds libffi
  shellHook = ''
    export PKG_CONFIG_PATH="${pkgs.libffi.out}/lib/pkgconfig:$PKG_CONFIG_PATH"
    echo "PKG_CONFIG_PATH set to: $PKG_CONFIG_PATH"
  '';
}
