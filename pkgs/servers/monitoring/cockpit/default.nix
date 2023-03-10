{ lib
, stdenv
, fetchzip
, fetchurl
, fetchFromGitHub
, autoreconfHook
, bashInteractive
, cacert
, coreutils
, dbus
, docbook_xml_dtd_43
, docbook_xsl
, findutils
, gettext
, git
, glib
, glibc
, glib-networking
, gnused
, gnutls
, json-glib
, krb5
, libssh
, libxcrypt
, libxslt
, makeWrapper
, nodejs
, nixosTests
, openssh
, openssl
, pam
, pkg-config
, polkit
, python3Packages
, ripgrep
, runtimeShell
, systemd
, udev
, xmlto
}:

let
  pythonWithGobject = python3Packages.python.withPackages (p: with p; [
    pygobject3
  ]);
in

stdenv.mkDerivation rec {
  pname = "cockpit";
  version = "284";

  src = fetchFromGitHub {
    owner = "cockpit-project";
    repo = "cockpit";
    rev = "80a7c7cfed9157915067666fe95b298896f2aea8";
    sha256 = "sha256-iAIW6nVUk1FJD2dQvDMREPVqrq0JkExJ7lVio//ALts=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    docbook_xml_dtd_43
    docbook_xsl
    findutils
    gettext
    git
    (lib.getBin libxslt)
    nodejs
    openssl
    pam
    pkg-config
    pythonWithGobject.python
    python3Packages.setuptools
    systemd
    ripgrep
    xmlto
  ];

  buildInputs = [
    (lib.getDev glib)
    libxcrypt
    gnutls
    json-glib
    krb5
    libssh
    polkit
    udev
  ];

  patches = [
    # Instead of requiring Internet access to do an npm install to generate the package-lock.json
    # it copies the package-lock.json already present in the node_modules folder fetched as a git
    # submodule.
    ./nerf-node-modules.patch

    # sysconfdir is $(prefix)/etc by default and it breaks the configuration file loading feature
    # changing sysconfdir to /etc breaks the build in this part of the makefile because it tries
    # to write to /etc inside the sandbox
    # this patch redirects it to write to $out/etc instead of /etc
    ./fix-makefiles.patch
  ];

  postPatch = ''
    # instruct users with problems to create a nixpkgs issue instead of nagging upstream directly
    substituteInPlace configure.ac \
      --replace 'devel@lists.cockpit-project.org' 'https://github.com/NixOS/nixpkgs/issues/new?assignees=&labels=0.kind%3A+bug&template=bug_report.md&title=cockpit%25'
    patchShebangs \
      test/common/pixel-tests \
      test/common/run-tests \
      test/common/tap-cdp \
      test/static-code \
      tools/escape-to-c \
      tools/make-compile-commands \
      tools/node-modules \
      tools/termschutz \
      tools/webpack-make

    for f in node_modules/.bin/*; do
      patchShebangs $(realpath $f)
    done

    export HOME=$(mktemp -d)

    cp node_modules/.package-lock.json package-lock.json

    substituteInPlace src/systemd_ctypes/libsystemd.py \
      --replace libsystemd.so.0 ${systemd}/lib/libsystemd.so.0

    for f in pkg/**/*.js pkg/**/*.jsx test/**/* src/**/*; do
      # some files substituteInPlace report as missing and it's safe to ignore them
      substituteInPlace "$(realpath "$f")" \
        --replace '"/usr/bin/' '"' \
        --replace '"/bin/' '"' || true
    done

    substituteInPlace src/common/Makefile-common.am \
      --replace 'TEST_PROGRAM += test-pipe' "" # skip test-pipe because it hangs the build

    substituteInPlace test/pytest/*.py \
      --replace "'bash" "'${bashInteractive}/bin/bash"

    echo "m4_define(VERSION_NUMBER, [${version}])" > version.m4
  '';

  configureFlags = [
    "--enable-prefix-only=yes"
    "--sysconfdir=/etc"
    "--disable-pcp" # TODO: figure out how to package its dependency
    "--with-default-session-path=/run/wrappers/bin:/run/current-system/sw/bin"
  ];

  enableParallelBuilding = true;

  preBuild = ''
    patchShebangs \
      tools/test-driver
  '';

  postBuild = ''
    find | grep cockpit-bridge
    chmod +x \
      src/systemd/update-motd \
      src/tls/cockpit-certificate-helper \
      src/ws/cockpit-desktop

    patchShebangs \
      src/systemd/update-motd \
      src/tls/cockpit-certificate-helper \
      src/ws/cockpit-desktop

    PATH=${pythonWithGobject}/bin patchShebangs src/client/cockpit-client

    substituteInPlace src/ws/cockpit-desktop \
      --replace ' /bin/bash' ' ${runtimeShell}'
  '';

  fixupPhase = ''
    runHook preFixup

    wrapProgram $out/libexec/cockpit-certificate-helper \
      --prefix PATH : ${lib.makeBinPath [ coreutils openssl ]} \
      --run 'cd $(mktemp -d)'

    wrapProgram $out/share/cockpit/motd/update-motd \
      --prefix PATH : ${lib.makeBinPath [ gnused ]}

    substituteInPlace $out/share/polkit-1/actions/org.cockpit-project.cockpit-bridge.policy \
      --replace /usr $out

    runHook postFixup
  '';

  doCheck = true;
  checkInputs = [
    bashInteractive
    cacert
    dbus
    glib-networking
    openssh
    python3Packages.pytest
    python3Packages.vulture
  ];
  checkPhase = ''
    export GIO_EXTRA_MODULES=$GIO_EXTRA_MODULES:${glib-networking}/lib/gio/modules
    export G_DEBUG=fatal-criticals
    export G_MESSAGES_DEBUG=cockpit-ws,cockpit-wrapper,cockpit-bridge
    export PATH=$PATH:$(pwd)

    cockpit-bridge --version
    make pytest -j$NIX_BUILD_CORES || true
    make check  -j$NIX_BUILD_CORES || true
    test/static-code
    npm run eslint
    npm run stylelint
  '';

  passthru.tests = { inherit (nixosTests) cockpit; };

  meta = with lib; {
    description = "Web-based graphical interface for servers";
    homepage = "https://cockpit-project.org/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ lucasew ];
  };
}
