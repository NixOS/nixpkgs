{ lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "asphyxia-core";
  version = "1.40";

  src = fetchurl {
    url = "https://github.com/asphyxia-core/asphyxia-core.github.io/releases/download/v${version}/asphyxia-core-linux-x64.zip";
    sha256 = "sha256-YFAXHzxoLuKfflwqYvpifefRE2/KbShuQ0v+0LG7OCg=";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ stdenv.cc.cc.lib ];

  sourceRoot = ".";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    mv asphyxia-core $out/bin/asphyxia-core
  '';

  preFixup = ''
    orig_size=$(stat --printf=%s $out/bin/asphyxia-core)
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/asphyxia-core
    patchelf --set-rpath ${lib.makeLibraryPath [stdenv.cc.cc]} $out/bin/asphyxia-core
    chmod +x $out/bin/asphyxia-core
    new_size=$(stat --printf=%s $out/bin/asphyxia-core)
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
      location=$(grep -obUam1 "$1" $out/bin/asphyxia-core | cut -d: -f1)
      location=$(expr $location + $var_skip)
      value=$(dd if=$out/bin/asphyxia-core iflag=count_bytes,skip_bytes skip=$location \
                 bs=1 count=$var_select status=none)
      value=$(expr $shift_by + $value)
      echo -n $value | dd of=$out/bin/asphyxia-core bs=1 seek=$location conv=notrunc
    }
    fix_offset PAYLOAD_POSITION
    fix_offset PRELUDE_POSITION
  '';

  # this binary is very sensitive to parts of it being moved around / changed in length,
  # so avoid stripping it.
  dontStrip = true;


  meta = with lib; {
    description = ''An "e-amuse emulator", for running Konami rhythm games without connecting to the internet.'';
    homepage = "https://asphyxia-core.github.io/";
    license = licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
  };
}
