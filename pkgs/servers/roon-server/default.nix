{ alsa-lib
, alsa-utils
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
  pname = "roon-server";
  version = "1.8-831";

  # N.B. The URL is unstable. I've asked for them to provide a stable URL but
  # they have ignored me. If this package fails to build for you, you may need
  # to update the version and sha256.
  # c.f. https://community.roonlabs.com/t/latest-roon-server-is-not-available-for-download-on-nixos/118129
  src = fetchurl {
    url = "https://web.archive.org/web/20210921161727/http://download.roonlabs.com/builds/RoonServer_linuxx64.tar.bz2";
    sha256 = "sha256-SeMSC7K6DV7rVr1w/SqMnLvipoWbypS/gJnSZmpfXZk=";
  };

  buildInputs = [
    alsa-lib
    alsa-utils
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
        wrapProgram ${bin} --prefix PATH : ${lib.makeBinPath [ alsa-utils cifs-utils ffmpeg ]}
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
    description = "The music player for music lovers";
    changelog = "https://community.roonlabs.com/c/roon/software-release-notes/18";
    homepage = "https://roonlabs.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ lovesegfault steell ];
    platforms = platforms.linux;
  };
}
