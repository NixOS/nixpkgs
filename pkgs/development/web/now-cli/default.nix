{ stdenv, lib, fetchurl }:
stdenv.mkDerivation rec {
  name = "now-cli-${version}";
  version = "15.0.10";

  # TODO: switch to building from source, if possible
  src = fetchurl {
    url = "https://github.com/zeit/now-cli/releases/download/${version}/now-linux.gz";
    sha256 = "00w9bniz87jjvizl364hpfssvbl1y1fdzp0732j348x528px2krh";
  };

  sourceRoot = ".";
  unpackCmd = ''
    gunzip -c $curSrc > now-linux
  '';

  buildPhase = ":";

  installPhase = ''
    mkdir $out
    mkdir $out/bin
    cp now-linux $out/bin/now
  '';

    # now is a node program packaged using zeit/pkg.
    # thus, it contains hardcoded offsets.
    # patchelf shifts these locations when it expands headers.

    # this could probably be generalised into allowing any program packaged
    # with zeit/pkg to be run on nixos.

  preFixup = let
    libPath = lib.makeLibraryPath [stdenv.cc.cc];
  in ''

    orig_size=$(stat --printf=%s $out/bin/now)

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/now
    patchelf --set-rpath ${libPath} $out/bin/now
    chmod +x $out/bin/now

    new_size=$(stat --printf=%s $out/bin/now)

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
      location=$(grep -obUam1 "$1" $out/bin/now | cut -d: -f1)
      location=$(expr $location + $var_skip)

      value=$(dd if=$out/bin/now iflag=count_bytes,skip_bytes skip=$location \
                 bs=1 count=$var_select status=none)
      value=$(expr $shift_by + $value)

      echo -n $value | dd of=$out/bin/now bs=1 seek=$location conv=notrunc
    }

    fix_offset PAYLOAD_POSITION
    fix_offset PRELUDE_POSITION

  '';
  dontStrip = true;



  meta = with stdenv.lib; {
    homepage = https://zeit.co/now;
    description = "The Command Line Interface for Now - Global Serverless Deployments";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.bhall ];
  };
}
