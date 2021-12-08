{ lib, stdenv, fetchFromGitHub, v8, perl, postgresql }:

stdenv.mkDerivation rec {
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

  # Without this, PostgreSQL will crash at runtime.
  # The flags are only included in Makefile, not Makefile.shared.
  # https://github.com/plv8/plv8/pull/469
  NIX_CFLAGS_COMPILE = "-DJSONB_DIRECT_CONVERSION -DV8_COMPRESS_POINTERS=1 -DV8_31BIT_SMIS_ON_64BIT_ARCH=1";

  meta = with lib; {
    description = "V8 Engine Javascript Procedural Language add-on for PostgreSQL";
    homepage = "https://plv8.github.io/";
    maintainers = with maintainers; [ volth marsam ];
    platforms = [ "x86_64-linux" ];
    license = licenses.postgresql;
  };
}
