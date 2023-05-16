<<<<<<< HEAD
{ stdenv
, nixosTests
, lib
, pkg-config
, jansson
, pcre
, libxcrypt
, expat
, zlib
=======
{ stdenv, nixosTests, lib, pkg-config, jansson, pcre, libxcrypt
, expat, zlib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
# plugins: list of strings, eg. [ "python2" "python3" ]
, plugins ? []
, pam, withPAM ? stdenv.isLinux
, systemd, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, libcap, withCap ? stdenv.isLinux
, python2, python3, ncurses
, ruby, php
, makeWrapper, fetchFromGitHub
}:

<<<<<<< HEAD
let
  php-embed = php.override {
    embedSupport = true;
    apxs2Support = false;
  };

  pythonPlugin = pkg : lib.nameValuePair "python${if pkg.isPy2 then "2" else "3"}" {
    interpreter = pkg.pythonForBuild.interpreter;
    path = "plugins/python";
    inputs = [ pkg ncurses ];
    install = ''
      install -Dm644 uwsgidecorators.py $out/${pkg.sitePackages}/uwsgidecorators.py
      ${pkg.pythonForBuild.executable} -m compileall $out/${pkg.sitePackages}/
      ${pkg.pythonForBuild.executable} -O -m compileall $out/${pkg.sitePackages}/
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
    let
      all = lib.concatStringsSep ", " (lib.attrNames available);
    in
      if lib.hasAttr name available
      then lib.getAttr name available // { inherit name; }
      else throw "Unknown UWSGI plugin ${name}, available : ${all}";

  needed = builtins.map getPlugin plugins;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "uwsgi";
  version = "2.0.22";
=======
let php-embed = php.override {
      embedSupport = true;
      apxs2Support = false;
    };

    pythonPlugin = pkg : lib.nameValuePair "python${if pkg.isPy2 then "2" else "3"}" {
                           interpreter = pkg.pythonForBuild.interpreter;
                           path = "plugins/python";
                           inputs = [ pkg ncurses ];
                           install = ''
                             install -Dm644 uwsgidecorators.py $out/${pkg.sitePackages}/uwsgidecorators.py
                             ${pkg.pythonForBuild.executable} -m compileall $out/${pkg.sitePackages}/
                             ${pkg.pythonForBuild.executable} -O -m compileall $out/${pkg.sitePackages}/
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
  version = "2.0.21";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "unbit";
    repo = "uwsgi";
<<<<<<< HEAD
    rev = finalAttrs.version;
    hash = "sha256-pfy3EDXq3KVY2mC3BMAp/87IUiP4NhdTWZo+zVBJ+Pc=";
  };

  patches = [
    ./no-ext-session-php_session.h-on-NixOS.patch
    ./additional-php-ldflags.patch
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3
  ];

  buildInputs =  [ jansson pcre libxcrypt ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ expat zlib ]
    ++ lib.optional withPAM pam
    ++ lib.optional withSystemd systemd
    ++ lib.optional withCap libcap
    ++ lib.concatMap (x: x.inputs) needed;

  basePlugins =  lib.concatStringsSep ","
    (  lib.optional withPAM "pam"
    ++ lib.optional withSystemd "systemd_logger"
    );
=======
    rev = version;
    sha256 = "sha256-TUASYDyG+p1tlhmqi+ivaC7aW6UZBrPTFQUTYys5ICE=";
  };

  patches = [
        ./no-ext-session-php_session.h-on-NixOS.patch
        ./additional-php-ldflags.patch
  ];

  nativeBuildInputs = [ python3 pkg-config makeWrapper ];

  buildInputs =  [ jansson pcre libxcrypt ]
              ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ expat zlib ]
              ++ lib.optional withPAM pam
              ++ lib.optional withSystemd systemd
              ++ lib.optional withCap libcap
              ++ lib.concatMap (x: x.inputs) needed
              ;

  basePlugins =  lib.concatStringsSep ","
                 (  lib.optional withPAM "pam"
                 ++ lib.optional withSystemd "systemd_logger"
                 );
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  UWSGI_INCLUDES = lib.optionalString withCap "${libcap.dev}/include";

  passthru = {
    inherit python2 python3;
<<<<<<< HEAD
    tests.uwsgi = nixosTests.uwsgi;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    for f in uwsgiconfig.py plugins/*/uwsgiplugin.py; do
      substituteInPlace "$f" \
        --replace pkg-config "$PKG_CONFIG"
    done
    sed -e "s/ + php_version//" -i plugins/php/uwsgiplugin.py
  '';

  configurePhase = ''
<<<<<<< HEAD
    runHook preConfigure

    export pluginDir=$out/lib/uwsgi
    substituteAll ${./nixos.ini} buildconf/nixos.ini

    runHook postConfigure
=======
    export pluginDir=$out/lib/uwsgi
    substituteAll ${./nixos.ini} buildconf/nixos.ini
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  # this is a hack to make the php plugin link with session.so (which on nixos is a separate package)
  # the hack works in coordination with ./additional-php-ldflags.patch
<<<<<<< HEAD
  UWSGICONFIG_PHP_LDFLAGS = lib.optionalString
    (builtins.any (x: x.name == "php") needed)
    (lib.concatStringsSep "," [
      "-Wl"
      "-rpath=${php-embed.extensions.session}/lib/php/extensions/"
      "--library-path=${php-embed.extensions.session}/lib/php/extensions/"
      "-l:session.so"
    ]);

  buildPhase = ''
    runHook preBuild

    mkdir -p $pluginDir
    python3 uwsgiconfig.py --build nixos
    ${lib.concatMapStringsSep ";" (x: "${x.preBuild or ""}\n ${x.interpreter or "python3"} uwsgiconfig.py --plugin ${x.path} nixos ${x.name}") needed}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 uwsgi $out/bin/uwsgi
    ${lib.concatMapStringsSep "\n" (x: x.install or "") needed}

    runHook postInstall
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  postFixup = lib.optionalString (builtins.any (x: x.name == "php") needed)
  ''
    wrapProgram $out/bin/uwsgi --set PHP_INI_SCAN_DIR ${php-embed}/lib
  '';

<<<<<<< HEAD
  meta = {
    description = "A fast, self-healing and developer/sysadmin-friendly application container server coded in pure C";
    homepage = "https://uwsgi-docs.readthedocs.org/en/latest/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ abbradar schneefux globin ];
    platforms = lib.platforms.unix;
  };
})
=======
  meta = with lib; {
    homepage = "https://uwsgi-docs.readthedocs.org/en/latest/";
    description = "A fast, self-healing and developer/sysadmin-friendly application container server coded in pure C";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar schneefux globin ];
    platforms = platforms.unix;
  };

  passthru.tests.uwsgi = nixosTests.uwsgi;

}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
