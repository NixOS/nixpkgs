{
<<<<<<< HEAD
  bash,
  lib,
  buildFishPlugin,
  fetchFromGitHub,
=======
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  gnused,
  bash,
  coreutils,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildFishPlugin {
  pname = "foreign-env";
<<<<<<< HEAD
  version = "0-unstable-2023-08-23";
=======
  version = "0-unstable-2020-02-09";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-foreign-env";
<<<<<<< HEAD
    rev = "7f0cf099ae1e1e4ab38f46350ed6757d54471de7";
    hash = "sha256-4+k5rSoxkTtYFh/lEjhRkVYa2S4KEzJ/IJbyJl+rJjQ=";
  };

  preInstall = ''
    sed -i -e "s|bash|${lib.getExe bash}|" functions/fenv.main.fish
  '';

  meta = {
    description = "Foreign environment interface for Fish shell";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jgillich
      prince213
    ];
    platforms = with lib.platforms; unix;
=======
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
    description = "Foreign environment interface for Fish shell";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich ];
    platforms = with platforms; unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
