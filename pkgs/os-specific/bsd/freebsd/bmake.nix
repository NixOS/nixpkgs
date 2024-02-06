{ stdenv, lib, mkDerivation, bsdSetupHook, freebsdSetupHook, buildFreebsd, hostVersion, ... }:
mkDerivation {
  path = "contrib/bmake";
  version = "9.2";
  postPatch = ''
    # make needs this to pick up our sys make files
    export NIX_CFLAGS_COMPILE+=" -D_PATH_DEFSYSPATH=\"$out/share/mk\" -D_GNU_SOURCE"

    sed -e '/\tunexport-env/d' -e '/opt-keep-going/d' -i contrib/bmake/unit-tests/Makefile
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace $BSDSRCDIR/share/mk/bsd.sys.mk \
      --replace '-Wl,--fatal-warnings' "" \
      --replace '-Wl,--warn-shared-textrel' ""
  '' + lib.optionalString (stdenv.targetPlatform.isFreeBSD && hostVersion != "13.2") ''
    substituteInPlace $BSDSRCDIR/share/mk/local.sys.dirdeps.env.mk \
      --replace 'MK_host_egacy= yes' 'MK_host_egacy= no'
  '';
  #postInstall = ''
  #  make -C $BSDSRCDIR/share/mk FILESDIR=$out/share/mk install
  #'';
  extraPaths = [ "share/mk" "sys/conf/newvers.sh" "sys/sys/param.h" ]
    ++ lib.optional (!stdenv.hostPlatform.isFreeBSD) "tools/build/mk";
  skipIncludesPhase = true;
  buildInputs = [];
  nativeBuildInputs = [ bsdSetupHook freebsdSetupHook buildFreebsd.bmakeMinimal ];

  installPhase = ''
    runHook preInstall

    install -D bmake "$out/bin/bmake"
    ln -s "$out/bin/bmake" "$out/bin/make"
    mkdir -p "$out/share"
    cp -r "$BSDSRCDIR/share/mk" "$out/share/mk"
    find "$out/share/mk" -type f -print0 |
      while IFS= read -r -d "" f; do
        substituteInPlace "$f" --replace 'usr/' ""
      done
    substituteInPlace "$out/share/mk/bsd.symver.mk" \
      --replace '/share/mk' "$out/share/mk"

    runHook postInstall
  '';

  #postInstall = lib.optionalString (!stdenv.targetPlatform.isFreeBSD) ''
  #  boot_mk="$BSDSRCDIR/tools/build/mk"
  #  cp "$boot_mk"/Makefile.boot* "$out/share/mk"
  #  replaced_mk="$out/share/mk.orig"
  #  mkdir "$replaced_mk"
  #  mv "$out"/share/mk/bsd.{lib,prog}.mk "$replaced_mk"
  #  for m in bsd.{lib,prog}.mk; do
  #    cp "$boot_mk/$m" "$out/share/mk"
  #    substituteInPlace "$out/share/mk/$m" --replace '../../../share/mk' '../mk.orig'
  #  done
  #'';
}
