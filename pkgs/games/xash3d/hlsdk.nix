{ lib
, stdenv
, fetchFromGitHub
, cmake
, name
, version
, rev
, hash
, gamedir ? name
# changing these was not tested
, enableGoldsourceSupport ? true
, enableVoicemgr ? false
, enableBugfixes ? false
, enableCrowbarIdleAnim ? false
}:

stdenv.mkDerivation {
  pname = "hlsdk-${name}";
  inherit version;

  src = fetchFromGitHub {
    owner = "FWGS";
    repo = "hlsdk-portable";
    inherit rev hash;
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = let
    cmakeBool = (x: if x then "ON" else "OFF");
  in [
    "-DGAMEDIR=${gamedir}"
    "-DGOLDSOURCE_SUPPORT=${cmakeBool enableGoldsourceSupport}"
    "-DUSE_VOICEMGR=${cmakeBool enableVoicemgr}"
    "-DBARNACLE_FIX_VISIBILITY=${cmakeBool enableBugfixes}"
    "-DCROWBAR_DELAY_FIX=${cmakeBool enableBugfixes}"
    "-DCROWBAR_FIX_RAPID_CROWBAR=${cmakeBool enableBugfixes}"
    "-DGAUSS_OVERCHARGE_FIX=${cmakeBool enableBugfixes}"
    "-DTRIPMINE_BEAM_DUPLICATION_FIX=${cmakeBool enableBugfixes}"
    "-DHANDGRENADE_DEPLOY_FIX=${cmakeBool enableBugfixes}"
    "-DWEAPONS_ANIMATION_TIMES_FIX=${cmakeBool enableBugfixes}"
    "-DCROWBAR_IDLE_ANIM=${cmakeBool enableCrowbarIdleAnim}"
  ] ++ (lib.optional stdenv.is64bit "-D64BIT=ON");

  meta = with lib; {
    description = "Portable Half-Life SDK for the game ${name}";
    homepage = "https://github.com/FWGS/hlsdk-portable";
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ TheBrainScrambler ];
    platforms = platforms.linux;
  };
}
