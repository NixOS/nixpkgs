{ stdenv, fetchFromGitHub, pkgconfig, symlinkJoin, qmake, diffPlugins
, qtbase, qtmultimedia, taglib, libmediainfo, libzen, libbass }:

let
  version = "2017-05-24";
  rev = "eed5dc41c849ab29b2dee37d97852fffdb45e390";
  sha256 = "1ymdgaffazndg9vhh47qqjr5873ld7j066hycp670r08bm519ysg";
  buildInputs = [ qtbase qtmultimedia taglib libmediainfo libzen libbass ];

  plugins = [
    "albumartex"
    "amazon"
    "audiotag"
    "cleanup"
    "freecovers"
    "lyric"
    "preparatory"
    "rename"
 ];

  patchedSrc =
    let src = fetchFromGitHub {
      owner = "UltraStar-Deluxe";
      repo = "UltraStar-Manager";
      inherit rev sha256;
    };
    in stdenv.mkDerivation {
      name = "${src.name}-patched";
      inherit src;
      phases = [ "unpackPhase" "patchPhase" ];

      patchPhase = with stdenv.lib; ''
        # we don’t want prebuild binaries checked into version control!
        rm -rf lib include

        # fix up main project file
        sed -e 's|-L.*unix.*lbass.*$|-lbass|' \
            -e "/QMAKE_POST_LINK/d" \
            -e "s|../include/bass|${getLib libbass}/include|g" \
            -e "s|../include/taglib|${getLib taglib}/include|g" \
            -e "s|../include/mediainfo|${getLib libmediainfo}/include|g" \
            -i src/UltraStar-Manager.pro

        # if more plugins start depending on ../../../include,
        # it should be abstracted out for all .pro files
        sed -e "s|../../../include/taglib|${getLib taglib}/include/taglib|g" \
            -i src/plugins/audiotag/audiotag.pro

        mkdir $out
        mv * $out
      '';
    };

  patchApplicationPath = file: path: ''
    sed -e "s|QCore.*applicationDirPath()|QString(\"${path}\")|" -i "${file}"
  '';

  buildPlugin = name: stdenv.mkDerivation {
    name = "ultrastar-manager-${name}-plugin-${version}";
    src = patchedSrc;

    buildInputs = [ qmake ] ++ buildInputs;

    postPatch = ''
      sed -e "s|DESTDIR = .*$|DESTDIR = $out|" \
          -i src/plugins/${name}/${name}.pro

      # plugins use the application’s binary folder (wtf)
      for f in $(grep -lr "QCoreApplication::applicationDirPath" src/plugins); do
        ${patchApplicationPath "$f" "\$out"}
      done

    '';
    preConfigure = ''
      cd src/plugins/${name}
    '';
  };

  builtPlugins =
    symlinkJoin {
      name = "ultrastar-manager-plugins-${version}";
      paths = map buildPlugin plugins;
    };

in stdenv.mkDerivation {
  name = "ultrastar-manager-${version}";
  src = patchedSrc;

  postPatch = ''
    sed -e "s|DESTDIR =.*$|DESTDIR = $out/bin|" \
        -i src/UltraStar-Manager.pro
    # patch plugin manager to point to the collected plugin folder
    ${patchApplicationPath "src/plugins/QUPluginManager.cpp" builtPlugins}
  '';

  buildPhase = ''
    find -path './src/plugins/*' -prune -type d -print0 \
      | xargs -0 -i'{}' basename '{}' \
      | sed -e '/shared/d' \
      > found_plugins
    ${diffPlugins plugins "found_plugins"}

    cd src && qmake && make
  '';

  # is not installPhase so that qt post hooks can run
  preInstall = ''
    make install
  '';

  nativeBuildInputs = [ pkgconfig ];
  inherit buildInputs;

  meta = with stdenv.lib; {
    description = "Ultrastar karaoke song manager";
    homepage = https://github.com/UltraStar-Deluxe/UltraStar-Manager;
    license = licenses.gpl2;
    maintainers = with maintainers; [ profpatsch ];
  };
}
