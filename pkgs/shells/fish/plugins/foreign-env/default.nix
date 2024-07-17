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
  version = "unstable-2020-02-09";

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

  meta = with lib; {
    description = "A foreign environment interface for Fish shell";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich ];
    platforms = with platforms; unix;
  };
}
