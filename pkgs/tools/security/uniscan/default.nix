{ lib, stdenv, fetchgit, perl, perlPackages, makeWrapper, copyDesktopItems, makeDesktopItem, xterm }:

let
  version = "6.3";
  src = fetchgit {
    url = "https://git.code.sf.net/p/uniscan/code";
    rev = "ef359f890ddff036544d6a733d540ebfd9be6981";
    sha256 = "0rxhps396cpc51svlrzdjg05000wx4craqg700na6393qhngh8iv";
  };

  metaCommon = with lib; {
    description = "A simple Remote File Include, Local File Include and Remote Command Execution vulnerability scanner";
    homepage = "https://sourceforge.net/projects/uniscan/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };

  uniscan = perlPackages.buildPerlPackage rec {
    pname = "uniscan";
    inherit version src;

    outputs = [ "out" ];

    # Add a helpful message prompting the user to create a config file
    patches = [ ./missing-config-warning.patch ];

    postPatch = ''
      substituteAllInPlace Uniscan/Configure.pm

      # Replace relative path to data files with store path
      substituteInPlace uniscan.pl \
        --replace '"Files"' "\"$out/share/uniscan/Files\"" \
        --replace '"Directory"' "\"$out/share/uniscan/Directory\""
      substituteInPlace Uniscan/Configure.pm \
        --replace "Languages/" "$out/share/uniscan/Languages/"
      substituteInPlace Uniscan/FingerPrint.pm \
        --replace "DB/" "$out/share/uniscan/DB/"
      substituteInPlace Uniscan/Factory.pm \
        --replace "Plugins/" "$out/share/uniscan/Plugins/"
      substituteInPlace Uniscan/Crawler.pm \
        --replace "./Plugins/" "$out/share/uniscan/Plugins/"
      substituteInPlace Uniscan/Scan.pm \
        --replace "./Plugins/" "$out/share/uniscan/Plugins/"
      substituteInPlace Uniscan/Stress.pm \
        --replace "./Plugins/" "$out/share/uniscan/Plugins/"

      rm uniscan_gui.pl
    '';

    nativeBuildInputs = [
      makeWrapper
    ];

    buildInputs = with perlPackages; [
      Moose
      LWP
      LWPProtocolHttps
      DevelOverloadInfo
    ];

    dontConfigure = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share
      cp -r . $out/share/uniscan

      runHook postInstall
    '';

    postFixup = ''
      makeWrapper "$out/share/uniscan/uniscan.pl" $out/bin/uniscan.pl \
        --set PERL5LIB "$PERL5LIB:$out/share/uniscan"
    '';

    meta = metaCommon // {
      mainProgram = "uniscan.pl";
    };
  };

  uniscan-gui = stdenv.mkDerivation rec {
    pname = "uniscan-gui";
    inherit version src;

    postPatch = ''
      substituteInPlace uniscan_gui.pl \
        --replace "xterm" "${xterm}/bin/xterm" \
        --replace "perl uniscan.pl" "${uniscan}/bin/uniscan.pl"
    '';

    desktopItems = [
      (makeDesktopItem {
        name = pname;
        desktopName = "Uniscan GUI";
        exec = "uniscan_gui.pl";
        comment = "A simple Remote File Include, Local File Include and Remote Command Execution vulnerability scanner";
        categories = [ "Utility" "Security" ];
        startupNotify = false;
      })
    ];

    nativeBuildInputs = [
      makeWrapper
      copyDesktopItems
    ];

    buildInputs = [
      (perl.withPackages (p: with p; [ Tk ]))
    ];

    installPhase = ''
      runHook preInstall

      install -Dm755 uniscan_gui.pl $out/bin/uniscan_gui.pl

      runHook postInstall
    '';

  postFixup = ''
    # 1. Ensure that a uniscan.conf exists in the current directory, or instantiate it
    # 2. Ensure that reports/ exists in the current directory, or instantiate it
    wrapProgram $out/bin/uniscan_gui.pl \
      --run "test -f uniscan.conf || (cp ${uniscan}/share/uniscan/uniscan.conf . && chmod +w uniscan.conf)" \
      --run "test -d report || (cp -r ${uniscan}/share/uniscan/report . && chmod -R +w report)"
  '';

    meta = metaCommon // {
      mainProgram = "uniscan_gui.pl";
    };
  };
in
{ inherit uniscan uniscan-gui; }
