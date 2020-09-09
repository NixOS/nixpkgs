{ alsaLib
, alsaUtils
, autoPatchelfHook
, cifs-utils
, fetchurl
, ffmpeg
, freetype
, lib
, makeWrapper
, stdenv
, zlib
}: stdenv.mkDerivation rec {
  name = "roon-server";
  version = "100700571";

  src = fetchurl {
    url = "http://download.roonlabs.com/updates/stable/RoonServer_linuxx64_${version}.tar.bz2";
    sha256 = "191vlzf10ypkk1prp6x2rszlmsihdwpd3wvgf2jg6ckwyxy2hc6k";
  };

  buildInputs = [
    alsaLib
    alsaUtils
    cifs-utils
    ffmpeg
    freetype
    zlib
  ];

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    mv * $out
    runHook postInstall
  '';

  postFixup =
    let
      linkFix = bin: ''
        sed -i '/ulimit/d' ${bin}
        sed -i '/ln -sf/d' ${bin}
        ln -sf $out/RoonMono/bin/mono-sgen $out/RoonMono/bin/${builtins.baseNameOf bin}
      '';
      wrapFix = bin: ''
        wrapProgram ${bin} --prefix PATH : ${lib.makeBinPath [ alsaUtils cifs-utils ffmpeg ]}
      '';
    in
    ''
      ${linkFix "$out/Appliance/RAATServer"}
      ${linkFix "$out/Appliance/RoonAppliance"}
      ${linkFix "$out/Server/RoonServer"}

      sed -i '/which avconv/c\    WHICH_AVCONV=1' $out/check.sh
      sed -i '/^check_ulimit/d' $out/check.sh
      ${wrapFix "$out/check.sh"}
      ${wrapFix "$out/start.sh"}
    '';

  meta = with lib; {
    description = "The music player for music lovers.";
    homepage = "https://roonlabs.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ lovesegfault steell ];
    platforms = platforms.linux;
  };
}
