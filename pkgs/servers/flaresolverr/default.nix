{ pkgs, stdenv }:
with pkgs;

stdenv.mkDerivation rec {

  pname = "flaresolverr";
  version = "2.2.6";

  src = fetchurl {
    url = "https://github.com/FlareSolverr/FlareSolverr/releases/download/v${version}/flaresolverr-v${version}-linux-x64.zip";
    sha256 = "sha256-ou+hKcIn3NO1/ZzyP69LOtpd1NbATNUg6KDRxCbyen4=";
  };

  nativeBuildInputs = [
    unzip
  ];

  buildInputs = [ firefox ];

  preFixup =
    let
      libPath = lib.makeLibraryPath [ stdenv.cc.cc ];
    in
    ''
      orig_size=$(stat --printf=%s $out/bin/flaresolverr)
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/flaresolverr
      patchelf --set-rpath ${libPath} $out/bin/flaresolverr
      chmod +x $out/bin/flaresolverr
      new_size=$(stat --printf=%s $out/bin/flaresolverr)
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
        location=$(grep -obUam1 "$1" $out/bin/flaresolverr | cut -d: -f1)
        location=$(expr $location + $var_skip)
        value=$(dd if=$out/bin/flaresolverr iflag=count_bytes,skip_bytes skip=$location \
                   bs=1 count=$var_select status=none)
        value=$(expr $shift_by + $value)
        echo -n $value | dd of=$out/bin/flaresolverr bs=1 seek=$location conv=notrunc
      }
      fix_offset PAYLOAD_POSITION
      fix_offset PRELUDE_POSITION
    '';

  installPhase = ''
    mkdir -p $out/bin
    cp flaresolverr $out/bin/
    mkdir -p $out/bin/firefox
    ln -s ${pkgs.firefox}/bin/firefox $out/bin/firefox/firefox
  '';

  dontStrip = true;

  meta = with lib; {
    description = "Proxy server to bypass Cloudflare protection";
    homepage = "https://github.com/FlareSolverr/FlareSolverr";
    license = licenses.mit;
    maintainers = with maintainers; [ julienmalka ];
  };


}
