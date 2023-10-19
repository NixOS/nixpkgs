{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, writeText
, shellspec
, fetchpatch
  # usage:
  # pkgs.mommy.override {
  #  mommySettings.sweetie = "catgirl";
  # }
  #
  # $ mommy
  # who's my good catgirl~
, mommySettings ? null
}:

let
  variables = lib.mapAttrs'
    (name: value: lib.nameValuePair "MOMMY_${lib.toUpper name}" value)
    mommySettings;
  configFile = writeText "mommy-config" (lib.toShellVars variables);
in
stdenv.mkDerivation rec {
  pname = "mommy";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "FWDekker";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LT21MJg2rF84o2rWKguEP4UUOOu27nNGls95sBYgICw=";
  };

  patches = [
    # 🫣 mommy finds your config with an environment variable now~
    (fetchpatch {
      url = "https://github.com/FWDekker/mommy/commit/d5785521fe2ce9ec832dbfe20abc483545b1df97.patch";
      hash = "sha256-GacUjQyvvwRRYKIHHTTAL0mQSPMZbbxacqilBaw807Y=";
    })
    # 💜 mommy follows the XDG base directory specification now~
    (fetchpatch {
      url = "https://github.com/FWDekker/mommy/commit/71806bc0ace2822ac32dc8dd5bb0b0881d849982.patch";
      hash = "sha256-Znq3VOgYI7a13Fqyz9nevtrvn7S5Jb2uBc78D0BG8rY=";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];
  nativeCheckInputs = [ shellspec ];
  installFlags = [ "prefix=$(out)" ];

  doCheck = true;
  checkTarget = "test/unit";

  postInstall = ''
    ${lib.optionalString (mommySettings != null) ''
      wrapProgram $out/bin/mommy \
        --set-default MOMMY_OPT_CONFIG_FILE "${configFile}"
    ''}
  '';

  meta = with lib; {
    description = "mommy's here to support you, in any shell, on any system~ ❤️";
    homepage = "https://github.com/FWDekker/mommy";
    changelog = "https://github.com/FWDekker/mommy/blob/v${version}/CHANGELOG.md";
    license = licenses.unlicense;
    platforms = platforms.all;
    maintainers = with maintainers; [ ckie ];
    mainProgram = "mommy";
  };
}
