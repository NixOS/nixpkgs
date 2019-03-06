{ stdenv, fetchurl, dpkg }:

stdenv.mkDerivation rec {
  pname = "fx_cast_bridge";
  version = "0.0.3";

  src = fetchurl {
     url = "https://github.com/hensm/fx_cast/releases/download/v${version}/fx_cast_bridge-${version}-x64.deb";
     sha256 = "0wqm0spmffn31yd23ych6fjxhzfxhj92379h0qdjh2xr3as4yh4n";
  };

  nativeBuildInputs = [ dpkg ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src ./
    runHook postUnpack
  '';

  dontBuild = true;
  dontPatchELF = true;

  installPhase = ''
    install -DT {opt/fx_cast,$out/bin}/bridge
    install -DT {usr,$out}/lib/mozilla/native-messaging-hosts/fx_cast_bridge.json

    substituteInPlace $out/lib/mozilla/native-messaging-hosts/fx_cast_bridge.json \
      --replace /opt/fx_cast/bridge $out/bin/bridge
  '';

  # See now-cli/default.nix
  dontStrip = true;
  preFixup = let
    libPath = stdenv.lib.makeLibraryPath [stdenv.cc.cc];
    bin = "$out/bin/bridge";
  in ''

    orig_size=$(stat --printf=%s ${bin})

    patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" ${bin}
    patchelf --set-rpath ${libPath} ${bin}
    chmod +x ${bin}

    new_size=$(stat --printf=%s ${bin})

    ###### zeit-pkg fixing starts here.
    # we're replacing plaintext js code that looks like
    # PAYLOAD_POSITION = '1234                  ' | 0
    # [...]
    # PRELUDE_POSITION = '1234                  ' | 0
    # ^-----20-chars-----^^------22-chars------^
    # ^-- grep points here
    #
    # var_* are as described above
    # shift_by seems to be safe so long as all patchelf adjustments occur
    # before any locations pointed to by hardcoded offsets

    var_skip=20
    var_select=22
    shift_by=$(expr $new_size - $orig_size)

    function fix_offset {
      # $1 = name of variable to adjust
      location=$(grep -obUam1 "$1" ${bin} | cut -d: -f1)
      location=$(expr $location + $var_skip)

      value=$(dd if=${bin} iflag=count_bytes,skip_bytes skip=$location \
                 bs=1 count=$var_select status=none)
      value=$(expr $shift_by + $value)

      echo -n $value | dd of=${bin} bs=1 seek=$location conv=notrunc
    }

    fix_offset PAYLOAD_POSITION
    fix_offset PRELUDE_POSITION

  '';

  meta = with stdenv.lib; {
    description = "Implementation of the Chrome Sender API (Chromecast) within Firefox";
    homepage = https://hensm.github.io/fx_cast/;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
