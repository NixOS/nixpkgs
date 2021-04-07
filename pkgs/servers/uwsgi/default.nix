{ stdenv, nixosTests, lib, fetchurl, pkg-config, jansson, pcre
# plugins: list of strings, eg. [ "python2" "python3" ]
, plugins ? []
, pam, withPAM ? stdenv.isLinux
, systemd, withSystemd ? stdenv.isLinux
, libcap, withCap ? stdenv.isLinux
, python2, python3, ncurses
, ruby, php
}:

let php-embed = php.override {
      embedSupport = true;
      apxs2Support = false;
    };

    pythonPlugin = pkg : lib.nameValuePair "python${if pkg.isPy2 then "2" else "3"}" {
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
                  (lib.nameValuePair "rack" {
                    path = "plugins/rack";
                    inputs = [ ruby ];
                  })
                  (lib.nameValuePair "cgi" {
                    # usage: https://uwsgi-docs.readthedocs.io/en/latest/CGI.html?highlight=cgi
                    path = "plugins/cgi";
                    inputs = [ ];
                  })
                  (lib.nameValuePair "php" {
                    # usage: https://uwsgi-docs.readthedocs.io/en/latest/PHP.html#running-php-apps-with-nginx
                    path = "plugins/php";
                    inputs = [
                        php-embed
                        php-embed.extensions.session
                        php-embed.extensions.session.dev
                        php-embed.unwrapped.dev
                    ] ++ php-embed.unwrapped.buildInputs;
                  })
                ];

    getPlugin = name:
      let all = lib.concatStringsSep ", " (lib.attrNames available);
      in if lib.hasAttr name available
         then lib.getAttr name available // { inherit name; }
         else throw "Unknown UWSGI plugin ${name}, available : ${all}";

    needed = builtins.map getPlugin plugins;
in

stdenv.mkDerivation rec {
  pname = "uwsgi";
  version = "2.0.19.1";

  src = fetchurl {
    url = "https://projects.unbit.it/downloads/${pname}-${version}.tar.gz";
    sha256 = "0256v72b7zr6ds4srpaawk1px3bp0djdwm239w3wrxpw7dzk1gjn";
  };

  patches = [
        ./no-ext-session-php_session.h-on-NixOS.patch
        ./additional-php-ldflags.patch
  ];

  nativeBuildInputs = [ python3 pkg-config ];

  buildInputs =  [ jansson pcre ]
              ++ lib.optional withPAM pam
              ++ lib.optional withSystemd systemd
              ++ lib.optional withCap libcap
              ++ lib.concatMap (x: x.inputs) needed
              ;

  basePlugins =  lib.concatStringsSep ","
                 (  lib.optional withPAM "pam"
                 ++ lib.optional withSystemd "systemd_logger"
                 );

  UWSGI_INCLUDES = lib.optionalString withCap "${libcap.dev}/include";

  passthru = {
    inherit python2 python3;
  };

  configurePhase = ''
    export pluginDir=$out/lib/uwsgi
    substituteAll ${./nixos.ini} buildconf/nixos.ini
  '';

  # this is a hack to make the php plugin link with session.so (which on nixos is a separate package)
  # the hack works in coordination with ./additional-php-ldflags.patch
  UWSGICONFIG_PHP_LDFLAGS = lib.optionalString (builtins.any (x: x.name == "php") needed)
        (lib.concatStringsSep "," [
            "-Wl"
            "-rpath=${php-embed.extensions.session}/lib/php/extensions/"
            "--library-path=${php-embed.extensions.session}/lib/php/extensions/"
            "-l:session.so"
        ]);

  buildPhase = ''
    mkdir -p $pluginDir
    python3 uwsgiconfig.py --build nixos
    ${lib.concatMapStringsSep ";" (x: "${x.preBuild or ""}\n ${x.interpreter or "python3"} uwsgiconfig.py --plugin ${x.path} nixos ${x.name}") needed}
  '';

  installPhase = ''
    install -Dm755 uwsgi $out/bin/uwsgi
    ${lib.concatMapStringsSep "\n" (x: x.install or "") needed}
  '';

  meta = with lib; {
    homepage = "https://uwsgi-docs.readthedocs.org/en/latest/";
    description = "A fast, self-healing and developer/sysadmin-friendly application container server coded in pure C";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar schneefux globin ];
    platforms = platforms.unix;
  };

  passthru.tests.uwsgi = nixosTests.uwsgi;

}
