{ rustup, runCommand, makeWrapper, pkgsHostTarget
, name ? (let p = builtins.parseDrvName rustup.name; in "${p.name}-with-dev-${p.version}")
, devPkgs }:

runCommand name {
  inherit (rustup) version;

  nativeBuildInputs = [ makeWrapper ];
  # Setup hook of pkg-config will set `$PKG_CONFIG_PATH`
  buildInputs = [ rustup pkgsHostTarget.pkg-config ] ++ devPkgs;
  preferLocalBuild = true;

} ''
  cp -r ${rustup} $out
  chmod -R +w $out
  wrapProgram $out/bin/rustup \
    --prefix PKG_CONFIG_PATH ":" "$PKG_CONFIG_PATH" \
    --prefix PATH ":" "${pkgsHostTarget.pkg-config}/bin"
''
