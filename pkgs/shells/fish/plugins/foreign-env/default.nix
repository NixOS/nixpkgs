{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  gnused,
  bash,
  coreutils,
}:

buildFishPlugin {
  pname = "foreign-env";
  version = "0-unstable-2020-02-09";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-foreign-env";
    rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
    sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
  };

  patches = [ ./suppress-harmless-warnings.patch ];

  preInstall = ''
    sed -e "s|sed|${gnused}/bin/sed|" \
        -e "s|bash|${bash}/bin/bash|" \
        -e "s|\| tr|\| ${coreutils}/bin/tr|" \
        -i functions/*
  '';

  meta = {
    description = "Foreign environment interface for Fish shell";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jgillich ];
    platforms = with lib.platforms; unix;
  };
}
