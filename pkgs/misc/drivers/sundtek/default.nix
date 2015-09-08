{ fetchurl, stdenv }:

with stdenv.lib;

let
  version = "2015-09-07";
  rpath = makeLibraryPath [ "$out/lib" "$out/bin" ];
  platform = with stdenv;
    if isx86_64 then "64bit"
    else
    if isi686 then "32bit"
    else abort "${system} not considered in build derivation. Might still be supported.";

in
  stdenv.mkDerivation {
    src = fetchurl {
      url = "http://www.sundtek.de/media/netinst/${platform}/installer.tar.gz";
      sha256 = "159221lxxs5a37akamp8jc3b5ny36451mgjljajvck0c6qb6fkpr";
    };
    name = "sundtek-${version}";

    phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

    sourceRoot = ".";

    installPhase = ''
      cp -r opt $out

      # add and fix pkg-config file
      mkdir -p $out/lib/pkgconfig
      substitute $out/doc/libmedia.pc $out/lib/pkgconfig/libmedia.pc \
        --replace /opt $out
    '';

    postFixup = ''
      find $out -type f -exec \
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" {} \
        patchelf --set-rpath ${rpath} {} \;
    '';

    meta = {
      description = "Sundtek MediaTV driver";
      maintainers = [ maintainers.simonvandel ];
      platforms = platforms.unix;
      license = licenses.unfree;
      homepage = "http://support.sundtek.com/index.php/topic,1573.0.html";
    };
  }
