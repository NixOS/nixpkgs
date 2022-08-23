{ lib, stdenv, fetchFromGitHub, v8, perl, postgresql
# For test
, runCommand, coreutils, gnugrep }:

let self = stdenv.mkDerivation rec {
  pname = "plv8";
  version = "3.0.0";

  nativeBuildInputs = [ perl ];
  buildInputs = [ v8 postgresql ];

  src = fetchFromGitHub {
    owner = "plv8";
    repo = "plv8";
    rev = "v${version}";
    sha256 = "KJz8wnGcTXnVn6umpP+UquuJTtQrkBTJ33rB/JIH4kU=";
  };

  makefile = "Makefile.shared";

  buildFlags = [ "all" ];

  makeFlags = [
    # Nixpkgs build a v8 monolith instead of separate v8_libplatform.
    "V8_OUTDIR=${v8}/lib"
  ];

  installFlags = [
    # PGXS only supports installing to postgresql prefix so we need to redirect this
    "DESTDIR=${placeholder "out"}"
  ];

  preConfigure = ''
    # We build V8 as a monolith, so this is unnecessary.
    substituteInPlace Makefile.shared --replace "-lv8_libplatform" ""
    patchShebangs ./generate_upgrade.sh
    substituteInPlace generate_upgrade.sh \
      --replace " 2.3.10)" " 2.3.10 2.3.11 2.3.12 2.3.13 2.3.14 2.3.15)"
  '';

  postInstall = ''
    # Move the redirected to proper directory.
    # There appear to be no references to the install directories
    # so changing them does not cause issues.
    mv "$out/nix/store"/*/* "$out"
    rmdir "$out/nix/store"/* "$out/nix/store" "$out/nix"
  '';

  NIX_CFLAGS_COMPILE = [
    # V8 depends on C++14.
    "-std=c++14"
    # Without this, PostgreSQL will crash at runtime.
    # The flags are only included in Makefile, not Makefile.shared.
    # https://github.com/plv8/plv8/pull/469
    "-DJSONB_DIRECT_CONVERSION" "-DV8_COMPRESS_POINTERS=1" "-DV8_31BIT_SMIS_ON_64BIT_ARCH=1"
  ];

  passthru.tests.smoke = runCommand "${pname}-test" {} ''
    export PATH=${lib.makeBinPath [ (postgresql.withPackages (_: [self])) coreutils gnugrep ]}
    db="$PWD/testdb"
    initdb "$db"
    postgres -k "$db" -D "$db" &
    pid="$!"

    for i in $(seq 1 100); do
      if psql -h "$db" -d postgres -c "" 2>/dev/null; then
        break
      elif ! kill -0 "$pid"; then
        exit 1
      else
        sleep 0.1
      fi
    done

    psql -h "$db" -d postgres -c 'CREATE EXTENSION plv8; DO $$ plv8.elog(NOTICE, plv8.version); $$ LANGUAGE plv8;' 2> "$out"
    grep -q "${version}" "$out"
    kill -0 "$pid"
  '';

  meta = with lib; {
    description = "V8 Engine Javascript Procedural Language add-on for PostgreSQL";
    homepage = "https://plv8.github.io/";
    maintainers = with maintainers; [ marsam ];
    platforms = [ "x86_64-linux" ];
    license = licenses.postgresql;
  };
}; in self
