let
  # inspircd ships a few extra modules that users can load
  # via configuration. Upstream thus recommends to ship as
  # many of them as possible. There is however a problem:
  # inspircd is licensed under the GPL version 2 only and
  # some modules link libraries that are incompatible with
  # the GPL 2. Therefore we can't provide them as binaries
  # via our binary-caches, but users should still be able
  # to override this package and build the incompatible
  # modules themselves.
  #
  # This means for us we need to a) prevent hydra from
  # building a module set with a GPL incompatibility
  # and b) dynamically figure out the largest possible
  # set of modules to use depending on stdenv, because
  # the used libc needs to be compatible as well.
  #
  # For an overview of all modules and their licensing
  # situation, see https://docs.inspircd.org/packaging/

  # Predicate for checking license compatibility with
  # GPLv2. Since this is _only_ used for libc compatibility
  # checking, only whitelist licenses used by notable
  # libcs in nixpkgs (musl and glibc).
  compatible = lib: drv:
    lib.any (lic: lic == (drv.meta.license or {})) [
      lib.licenses.mit        # musl
      lib.licenses.lgpl2Plus  # glibc
    ];

  # compatible if libc is compatible
  libcModules = [
    "regex_posix"
    "sslrehashsignal"
  ];

  # compatible if libc++ is compatible
  # TODO(sternenseemann):
  # we could enable "regex_stdlib" automatically, but only if
  # we are using libcxxStdenv which is compatible with GPLv2,
  # since the gcc libstdc++ license is GPLv2-incompatible
  libcxxModules = [
    "regex_stdlib"
  ];

  compatibleModules = lib: stdenv: [
    # GPLv2 compatible dependencies
    "argon2"
    "ldap"
    "mysql"
    "pgsql"
    "regex_pcre"
    "regex_pcre2"
    "regex_re2"
    "regex_tre"
    "sqlite3"
    "ssl_gnutls"
  ] ++ lib.optionals (compatible lib stdenv.cc.libc) libcModules;

in

{ lib
, stdenv
, fetchFromGitHub
, nixosTests
, perl
, pkg-config
, libargon2
, openldap
, postgresql
, libmysqlclient
, pcre
, pcre2
, tre
, re2
, sqlite
, gnutls
, libmaxminddb
, openssl
, mbedtls
# For a full list of module names, see https://docs.inspircd.org/packaging/
, extraModules ? compatibleModules lib stdenv
}:

let
  extras = {
    # GPLv2 compatible
    argon2 = [
      (libargon2 // {
        meta = libargon2.meta // {
          # use libargon2 as CC0 since ASL20 is GPLv2-incompatible
          # updating this here is important that meta.license is accurate
          # libargon2 is licensed under either ASL20 or CC0.
          license = lib.licenses.cc0;
        };
      })
    ];
    ldap            = [ openldap ];
    mysql           = [ libmysqlclient ];
    pgsql           = [ postgresql ];
    regex_pcre      = [ pcre ];
    regex_pcre2     = [ pcre2 ];
    regex_re2       = [ re2 ];
    regex_tre       = [ tre ];
    sqlite3         = [ sqlite ];
    ssl_gnutls      = [ gnutls ];
    # depends on stdenv.cc.libc
    regex_posix     = [];
    sslrehashsignal = [];
    # depends on used libc++
    regex_stdlib    = [];
    # GPLv2 incompatible
    geo_maxmind     = [ libmaxminddb ];
    ssl_mbedtls     = [ mbedtls ];
    ssl_openssl     = [ openssl ];
  };

  # buildInputs necessary for the enabled extraModules
  extraInputs = lib.concatMap
    (m: extras."${m}" or (builtins.throw "Unknown extra module ${m}"))
    extraModules;

  # if true, we can't provide a binary version of this
  # package without violating the GPL 2
  gpl2Conflict =
    let
      allowed = compatibleModules lib stdenv;
    in
      !lib.all (lib.flip lib.elem allowed) extraModules;

  # return list of the license(s) of the given derivation
  getLicenses = drv:
    let
      lics = drv.meta.license or [];
    in
      if lib.isAttrs lics || lib.isString lics
      then [ lics ]
      else lics;

  # Whether any member of list1 is also member of list2, i. e. set intersection.
  anyMembers = list1: list2:
    lib.any (m1: lib.elem m1 list2) list1;

in

stdenv.mkDerivation rec {
  pname = "inspircd";
  version = "3.17.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-isLZKYf32+va66FGYMq4mWIEHNpqUWCcVhYWLA5lRwk=";
  };

  outputs = [ "bin" "lib" "man" "doc" "out" ];

  nativeBuildInputs = [
    perl
    pkg-config
  ];
  buildInputs = extraInputs;

  configurePhase = ''
    runHook preConfigure

    patchShebangs configure make/*.pl

    # configure is executed twice, once to set the extras
    # to use and once to do the Makefile setup
    ./configure \
      --enable-extras \
      ${lib.escapeShellArg (lib.concatStringsSep " " extraModules)}

    # this manually sets the flags instead of using configureFlags, because otherwise stdenv passes flags like --bindir, which make configure fail
    ./configure \
      --disable-auto-extras \
      --distribution-label nixpkgs${version} \
      --uid 0 \
      --gid 0 \
      --binary-dir  ${placeholder "bin"}/bin \
      --config-dir  /etc/inspircd \
      --data-dir    ${placeholder "lib"}/lib/inspircd \
      --example-dir ${placeholder "doc"}/share/doc/inspircd \
      --log-dir     /var/log/inspircd \
      --manual-dir  ${placeholder "man"}/share/man/man1 \
      --module-dir  ${placeholder "lib"}/lib/inspircd \
      --runtime-dir /var/run \
      --script-dir  ${placeholder "bin"}/share/inspircd \

    runHook postConfigure
  '';

  postInstall = ''
    # for some reasons the executables are not executable
    chmod +x $bin/bin/*
  '';

  enableParallelBuilding = true;

  passthru.tests = {
    nixos-test = nixosTests.inspircd;
  };

  meta = {
    description = "A modular C++ IRC server";
    license = [ lib.licenses.gpl2Only ]
      ++ lib.concatMap getLicenses extraInputs
      ++ lib.optionals (anyMembers extraModules libcModules) (getLicenses stdenv.cc.libc)
      # FIXME(sternenseemann): get license of used lib(std)c++ somehow
      ++ lib.optional (anyMembers extraModules libcxxModules) "Unknown"
      # Hack: Definitely prevent a hydra from building this package on
      # a GPL 2 incompatibility even if it is not in a top-level attribute,
      # but pulled in indirectly somehow.
      ++ lib.optional gpl2Conflict lib.licenses.unfree;
    maintainers = [ lib.maintainers.sternenseemann ];
    # windows is theoretically possible, but requires extra work
    # which I am not willing to do and can't test.
    # https://github.com/inspircd/inspircd/blob/master/win/README.txt
    platforms = lib.platforms.unix;
    homepage = "https://www.inspircd.org/";
  } // lib.optionalAttrs gpl2Conflict {
    # make sure we never distribute a GPLv2-violating module
    # in binary form. They can be built locally of course.
    hydraPlatforms = [];
  };
}
