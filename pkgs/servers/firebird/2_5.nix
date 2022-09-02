{ autoreconfHook
, fetchFromGitHub
, firebird
, lib
, libedit
, stdenv

### icu:
#     You may have trouble sharing database files with windows
#     users if "Collation unicode" columns are being used.
#     windows icu version is *30.dll, however neither the icu 3.0 nor the 3.6
#     sources look close to what ships with this package.
#     Thus I think its best to trust firebird devs and use their version.
#
#     icu version missmatch may cause such error when selecting from a table:
#       "Collation unicode for character set utf8 is not installed"
#
#     icu 3.0 can be built on nix (by dropping the #elif case and make | make)
, icu ? null
, superServer ? false
, port ? 3050
, serviceName ? "gds_db"
}:

stdenv.mkDerivation rec {
  pname = "firebird";
  version = "2.5.9";

  src = fetchFromGitHub {
    owner = "FirebirdSQL";
    repo = "firebird";
    rev = "R${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-YyvlMeBux80OpVhsCv+6IVxKXFRsgdr+1siupMR13JM=";
  };

  configureFlags = [
    "--with-serivec-port=${builtins.toString port}"
    "--with-service-name=${serviceName}"
    "--with-fbconf=/etc/firebird"
    "--with-fblog=/var/log/"
    "--with-fbglock=/run/firebird"
    "--with-fbsecure-db=/var/lib/firebird/system"
    "--with-fbmsg=/etc/firebird/"
    "--with-system-editline"
    (lib.optional (icu != null) "--with-system-icu")
    (lib.optional superServer "--enable-superserver")
  ];

  # Error: ../gen/firebird/bin/gpre_boot: No such file or directory
  # enableParallelBuilding = true;

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    icu
    libedit
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r gen/firebird/* $out
    ln -s $out/bin/fb${if superServer then "server" else "_smp_server"} $out/bin/firebird
    runHook postInstall
  '';

  meta = firebird.meta // {
    hydraPlatforms = [];
    platforms = [ "x86_64-linux" ];
    broken = false; # Firebird 2.5 is working at 2022-09-11
  };
}
