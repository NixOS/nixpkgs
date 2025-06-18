{
  buildEnv,
  lib,
  postgresql,
  postgresqlTestExtension,
  tclPackages,
}:

let
  withPackages =
    f:
    let
      pkgs = f tclPackages;
      paths = lib.concatMapStringsSep " " (pkg: "${pkg}/lib") pkgs;
      finalPackage = buildEnv {
        name = "${postgresql.pname}-pltcl-${postgresql.version}";
        paths = [ postgresql.pltcl ];
        passthru = {
          inherit withPackages;
          wrapperArgs = [
            ''--set TCLLIBPATH "${paths}"''
          ];
          tests.extension = postgresqlTestExtension {
            finalPackage = finalPackage.withPackages (ps: [
              ps.mustache-tcl
              ps.tcllib
            ]);
            sql = ''
              CREATE EXTENSION pltclu;
              CREATE FUNCTION test() RETURNS VOID
              LANGUAGE pltclu AS $$
                package require mustache
              $$;
              SELECT test();
            '';
          };
        };
        meta = {
          inherit (postgresql.meta)
            homepage
            license
            changelog
            teams
            platforms
            ;
          description = "PL/Tcl - Tcl Procedural Language";
        };
      };
    in
    finalPackage;
in
withPackages (_: [ ])
