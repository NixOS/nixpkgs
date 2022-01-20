{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, dpkg
, glib
, nodejs
}:

stdenv.mkDerivation rec {
  pname = "onlyoffice-documentserver";
  version = "7.0.0";
  src = fetchurl {
    url = "https://github.com/ONLYOFFICE/DocumentServer/releases/download/v${version}/onlyoffice-documentserver_amd64.deb";
    sha256 = "sha256-JhUKaPYPreyWSR2lUlIfnfm8X7wvEYMof9Yd9Xm/NZc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    glib
    nodejs
  ];

  unpackPhase = ''
    dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
  '';

  # docservice is a node program packaged using zeit/pkg.
  # thus, it contains hardcoded offsets.
  # patchelf shifts these locations when it expands headers.

  # this could probably be generalised into allowing any program packaged
  # with zeit/pkg to be run on nixos.

  preFixup = let
    libPath = lib.makeLibraryPath [stdenv.cc.cc];
  in ''
    orig_size=$(stat --printf=%s $out/bin/docservice)
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/docservice
    patchelf --set-rpath ${libPath} $out/bin/docservice
    chmod +x $out/bin/docservice
    new_size=$(stat --printf=%s $out/bin/docservice)
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
      location=$(grep -obUam1 "$1" $out/bin/docservice | cut -d: -f1)
      location=$(expr $location + $var_skip)
      value=$(dd if=$out/bin/docservice iflag=count_bytes,skip_bytes skip=$location \
                 bs=1 count=$var_select status=none)
      value=$(expr $shift_by + $value)
      echo -n $value | dd of=$out/bin/docservice bs=1 seek=$location conv=notrunc
    }
    fix_offset PAYLOAD_POSITION
    fix_offset PRELUDE_POSITION
  '';

  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/etc

    find -L var/www/onlyoffice/documentserver/server -mindepth 1 -type f -executable \
      -exec cp -d {} "$out/bin" \;

    find -L var/www/onlyoffice/documentserver/server -mindepth 1 -type f -name "*.so*" \
      -exec cp -d {} "$out/lib" \;

    substitute etc/onlyoffice/documentserver/production-linux.json $out/etc/production-linux.json \
      --replace "/var/www/onlyoffice/documentserver/dictionaries" "$out/dictionaries" \
      --replace "/var/lib/onlyoffice/documentserver/App_Data" "/var/lib/onlyoffice/documentserver/App_Data" \
      --replace "/var/www/onlyoffice/documentserver/core-fonts" "$out/core-fonts" \
      --replace "/var/lib/onlyoffice/documentserver/App_Data/docbuilder/AllFonts.js" "/var/lib/onlyoffice/App_Data/docbuilder/AllFonts.js" \
      --replace "/var/www/onlyoffice/documentserver/server/FileConverter/bin/docbuilder" "$out/bin/docbuilder" \
      --replace "/var/www/onlyoffice/documentserver/server/FileConverter/bin/x2t" "$out/bin/x2t" \
      --replace "/var/www/onlyoffice/documentserver/sdkjs-plugins" "$out/sdkjs-plugins" \
      --replace "/etc/onlyoffice/documentserver/log4js/production.json" "$out/etc/log4js-production.json"
    cp etc/onlyoffice/documentserver/log4js/production.json $out/etc/log4js-production.json

    runHook postInstall
  '';

  meta = with lib; {
    description = "Online office suite comprising viewers and editors for texts, spreadsheets and presentations, enabling collaborative editing in real time";
    homepage = "https://www.onlyoffice.com/";
    downloadPage = "https://github.com/ONLYOFFICE/DocumentServer/releases";
    changelog = "https://raw.githubusercontent.com/ONLYOFFICE/DocumentServer/master/CHANGELOG.md";
    platforms = [ "x86_64-linux" ];
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
