{ stdenv, lib, fetchurl, pkgconfig, jansson
# plugins: list of strings, eg. [python2, python3]
, plugins
, pam, withPAM ? stdenv.isLinux
, systemd, withSystemd ? stdenv.isLinux
, python2, python3, ncurses
}:

let pythonPlugin = pkg : { name = "python${if pkg ? isPy2 then "2" else "3"}";
                           interpreter = pkg;
                           path = "plugins/python";
                           deps = [ pkg ncurses ];
                           install = ''
                             install -Dm644 uwsgidecorators.py $out/${pkg.sitePackages}/uwsgidecorators.py
                             ${pkg.executable} -m compileall $out/${pkg.sitePackages}/
                             ${pkg.executable} -O -m compileall $out/${pkg.sitePackages}/
                           '';
                         };
    available = [ (pythonPlugin python2)
                  (pythonPlugin python3)
                ];
     needed = builtins.filter (x: lib.any (y: x.name == y) plugins) available;
in

assert builtins.filter (x: lib.all (y: y.name != x) available) plugins == [];

stdenv.mkDerivation rec {
  name = "uwsgi-2.0.11.2";

  src = fetchurl {
    url = "http://projects.unbit.it/downloads/${name}.tar.gz";
    sha256 = "0p482j4yi48bmpgx1qpdfk86hjn4dswb137jbmigdlrd9l5rp20b";
  };

  nativeBuildInputs = [ python3 pkgconfig ];

  buildInputs =  with stdenv.lib;
                 [ jansson ]
              ++ optional withPAM pam
              ++ optional withSystemd systemd
              ++ lib.concatMap (x: x.deps) needed
              ;

  basePlugins =  with stdenv.lib;
                 concatStringsSep ","
                 (  optional withPAM "pam"
                 ++ optional withSystemd "systemd_logger"
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
    ${lib.concatMapStringsSep ";" (x: "${x.interpreter.interpreter} uwsgiconfig.py --plugin ${x.path} nixos ${x.name}") needed}
  '';

  installPhase = ''
    install -Dm755 uwsgi $out/bin/uwsgi
    #cp *_plugin.so $pluginDir || true
    ${lib.concatMapStringsSep "\n" (x: x.install) needed}
  '';

  meta = with stdenv.lib; {
    homepage = http://uwsgi-docs.readthedocs.org/en/latest/;
    description = "A fast, self-healing and developer/sysadmin-friendly application container server coded in pure C";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
  };
}
