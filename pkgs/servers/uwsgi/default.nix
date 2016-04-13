{ stdenv, lib, fetchurl, pkgconfig, jansson
# plugins: list of strings, eg. [ "python2" "python3" ]
, plugins
, pam, withPAM ? false
, systemd, withSystemd ? false
, python2, python3, ncurses
}:

let pythonPlugin = pkg : lib.nameValuePair "python${if pkg ? isPy2 then "2" else "3"}" {
                           interpreter = pkg.interpreter;
                           path = "plugins/python";
                           inputs = [ pkg ncurses ];
                           install = ''
                             install -Dm644 uwsgidecorators.py $out/${pkg.sitePackages}/uwsgidecorators.py
                             ${pkg.executable} -m compileall $out/${pkg.sitePackages}/
                             ${pkg.executable} -O -m compileall $out/${pkg.sitePackages}/
                           '';
                         };

    available = lib.listToAttrs [
                  (pythonPlugin python2)
                  (pythonPlugin python3)
                ];

    getPlugin = name:
      let all = lib.concatStringsSep ", " (lib.attrNames available);
      in if lib.hasAttr name available
         then lib.getAttr name available // { inherit name; }
         else throw "Unknown UWSGI plugin ${name}, available : ${all}";

    needed = builtins.map getPlugin plugins;
in

stdenv.mkDerivation rec {
  name = "uwsgi-${version}";
  version = "2.0.12";

  src = fetchurl {
    url = "http://projects.unbit.it/downloads/${name}.tar.gz";
    sha256 = "02g46dnw5j1iw8fsq392bxbk8d21b9pdgb3ypcinv3b4jzdm2srh";
  };

  nativeBuildInputs = [ python3 pkgconfig ];

  buildInputs =  [ jansson ]
              ++ lib.optional withPAM pam
              ++ lib.optional withSystemd systemd
              ++ lib.concatMap (x: x.inputs) needed
              ;

  basePlugins =  lib.concatStringsSep ","
                 (  lib.optional withPAM "pam"
                 ++ lib.optional withSystemd "systemd_logger"
                 );

  passthru = {
    inherit python2 python3;
  };

  configurePhase = ''
    export pluginDir=$out/lib/uwsgi
    substituteAll ${./nixos.ini} buildconf/nixos.ini
  '';

  buildPhase = ''
    mkdir -p $pluginDir
    python3 uwsgiconfig.py --build nixos
    ${lib.concatMapStringsSep ";" (x: "${x.interpreter} uwsgiconfig.py --plugin ${x.path} nixos ${x.name}") needed}
  '';

  installPhase = ''
    install -Dm755 uwsgi $out/bin/uwsgi
    ${lib.concatMapStringsSep "\n" (x: x.install) needed}
  '';

  meta = with stdenv.lib; {
    homepage = http://uwsgi-docs.readthedocs.org/en/latest/;
    description = "A fast, self-healing and developer/sysadmin-friendly application container server coded in pure C";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
  };
}
