{ stdenv, cmake, openmw, fetchFromGitHub, luajit, makeWrapper }:

# revisions are taken from https://github.com/GrimKriegor/TES3MP-deploy

let
  # TES3MP_STABLE_VERSION_FILE
  compatHash = "292536439eeda58becdb7e441fe2e61ebb74529e";
  rakNet = fetchFromGitHub {
    owner = "TES3MP";
    repo = "CrabNet";
    # usually fixed:
    # https://github.com/GrimKriegor/TES3MP-deploy/blob/d2a4a5d3acb64b16d9b8ca85906780aeea8d311b/tes3mp-deploy.sh#L589
    rev = "4eeeaad2f6c11aeb82070df35169694b4fb7b04b";
    sha256 = "0p0li9l1i5lcliswm5w9jql0zff9i6fwhiq0bl130m4i7vpr4cr3";
  };
  rakNetLibrary = stdenv.mkDerivation {
    name = "RakNetLibrary";
    src = rakNet;
    nativeBuildInputs = [ cmake ];
    installPhase = ''
      install -Dm755 lib/libRakNetLibStatic.a $out/lib/libRakNetLibStatic.a
    '';
  };
  coreScripts = fetchFromGitHub {
    owner = "TES3MP";
    repo = "CoreScripts";
    # usually latest master
    rev = "71e15fa3b1d5131b6607ba1589f41c06672ce376";
    sha256 = "1kwii8rpsxjmz4dh06wb0qaix17hq5s1qsvysv6n6209vlclfxjg";
  };
in openmw.overrideAttrs (oldAttrs: rec {
  version = "2019-06-09";
  name = "openmw-tes3mp-${version}";

  src = fetchFromGitHub {
    owner = "TES3MP";
    repo = "openmw-tes3mp";
    # usually latest in stable branch (e.g. 0.7.0)
    rev = "01804af100785bc2c162d568258d9662012627a3";
    sha256 = "0j99v9vvmic0bqw3y4550k1dy058lwvs9s9qcjmxh1wkqkvrpdnp";
  };

  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ makeWrapper ];
  buildInputs = oldAttrs.buildInputs ++ [ luajit ];

  cmakeFlags = oldAttrs.cmakeFlags ++ [
    "-DBUILD_OPENCS=OFF"
    "-DRakNet_INCLUDES=${rakNet}/include"
    "-DRakNet_LIBRARY_RELEASE=${rakNetLibrary}/lib/libRakNetLibStatic.a"
    "-DRakNet_LIBRARY_DEBUG=${rakNetLibrary}/lib/libRakNetLibStatic.a"
  ];

  preConfigure = ''
    substituteInPlace files/version.in \
      --subst-var-by OPENMW_VERSION_COMMITHASH ${compatHash}
  '';

  postInstall = ''
    # components/process/processinvoker.cpp: path.prepend(QLatin1String("./"))
    wrapProgram $out/bin/tes3mp-browser \
      --run "cd $out/bin"
    wrapProgram $out/bin/tes3mp-server \
      --run "mkdir -p ~/.config/openmw" \
      --run "cd ~/.config/openmw" \
      --run "[ -d CoreScripts ] || cp --no-preserve=mode -r ${coreScripts} CoreScripts" \
      --run "[ -f tes3mp-server.cfg ] || echo \"[Plugins] home = \$HOME/.config/openmw/CoreScripts\" > tes3mp-server.cfg" \
      --run "cd $out/bin"
  '';

  meta = with stdenv.lib; {
    description = "Multiplayer for TES3:Morrowind based on OpenMW";
    homepage = https://tes3mp.com/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
})
