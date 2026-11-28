{
  lib,
  fetchFromGitHub,
  mkTclDerivation,
  autoreconfHook,
}:

mkTclDerivation (finalAttrs: {
  pname = "tclx";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "tclx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GK/8/tjwGdXVB1HNO2GqPwxnQKYSW0pbZvAYLp5QTqw=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  # required in order for tclx to properly detect tclx.tcl at runtime
  postInstall =
    let
      majorMinorVersion = lib.versions.majorMinor finalAttrs.version;
    in
    ''
      ln -s $prefix/lib/tclx${majorMinorVersion} $prefix/lib/tclx${majorMinorVersion}/tclx${majorMinorVersion}
    '';

  tclRequiresCheck = [ "Tclx" ];

  meta = {
    homepage = "https://github.com/flightaware/tclx";
    description = "Tcl extensions";
    license = lib.licenses.tcltk;
    maintainers = with lib.maintainers; [
      kovirobi
      fgaz
    ];
  };
})
