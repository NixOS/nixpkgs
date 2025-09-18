{
  buildEnv,
  perl,
  postgresql,
  postgresqlTestExtension,
}:

let
  withPackages =
    f:
    let
      perl' = perl.withPackages f;
      finalPackage = buildEnv {
        name = "${postgresql.pname}-plperl-${postgresql.version}";
        paths = [ postgresql.plperl ];
        passthru = {
          inherit withPackages;
          wrapperArgs = [
            ''--set PERL5LIB "${perl'}/${perl'.libPrefix}"''
          ];
          tests.extension = postgresqlTestExtension {
            finalPackage = finalPackage.withPackages (ps: [ ps.boolean ]);
            sql = ''
              CREATE EXTENSION plperlu;
              DO LANGUAGE plperlu $$
                use boolean;
              $$;
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
          description = "PL/Perl - Perl Procedural Language";
        };
      };
    in
    finalPackage;
in
withPackages (_: [ ])
