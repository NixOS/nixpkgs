{
  lib,
  derivationWithMeta,
  writeText,
  kaem,
  kaem-unwrapped,
  mescc-tools,
  mescc-tools-extra,
  version,
  platforms,
}:

# Once mescc-tools-extra is available we can install kaem at /bin/kaem
# to make it findable in environments
let commonBuildInputs = "${kaem}/bin:${mescc-tools}/bin:${mescc-tools-extra}/bin";
          in
derivationWithMeta {
  inherit version kaem-unwrapped;
  pname = "kaem";
  builder = kaem-unwrapped;
  args = [
    "--verbose"
    "--strict"
    "--file"
    (builtins.toFile "kaem-wrapper.kaem" ''
      mkdir -p ''${out}/bin
      cp ''${kaem-unwrapped} ''${out}/bin/kaem
      chmod 555 ''${out}/bin/kaem
    '')
  ];
  PATH = "${mescc-tools-extra}/bin";

  passthru.runCommand =
    name: env: buildCommand:
    derivationWithMeta (
      {
        inherit name;

        builder = "${kaem}/bin/kaem";
        args = [
          "--verbose"
          "--strict"
          "--file"
          ./default-builder.kaem
        ];
        cmd = buildCommand;
        passAsFile = [ "cmd" ];

        PATH = if env ? extraPath then "${env.extraPath}:${commonBuildInputs}" else commonBuildInputs;
      }
      // (removeAttrs env [ "nativeBuildInputs" ])
    );

  meta = {
    description = "Minimal build tool for running scripts on systems that lack any shell";
    homepage = "https://github.com/oriansj/mescc-tools";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.minimal-bootstrap ];
    inherit platforms;
  };
}
