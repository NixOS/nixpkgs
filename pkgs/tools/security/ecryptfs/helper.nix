{ lib, stdenv
, fetchurl
, makeWrapper
, python2
}:

stdenv.mkDerivation {
  pname   = "ecryptfs-helper";
  version = "20160722";

  src = fetchurl {
    url    = "https://gist.githubusercontent.com/obadz/ec053fdb00dcb48441d8313169874e30/raw/4b657a4b7c3dc684e4d5e3ffaf46ced1b7675163/ecryptfs-helper.py";
    sha256 = "0gp4m22zc80814ng80s38hp930aa8r4zqihr7jr23m0m2iq4pdpg";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  # Do not hardcode PATH to ${ecryptfs} as we need the script to invoke executables from /run/wrappers/bin
  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp $src $out/libexec/ecryptfs-helper.py
    makeWrapper "${python2.interpreter}" "$out/bin/ecryptfs-helper" --add-flags "$out/libexec/ecryptfs-helper.py"
  '';

  meta = with lib; {
    description    = "Helper script to create/mount/unemount encrypted directories using eCryptfs without needing root permissions";
    license        = licenses.gpl2Plus;
    maintainers    = with maintainers; [ obadz ];
    platforms      = platforms.linux;
    hydraPlatforms = [];
  };
}
