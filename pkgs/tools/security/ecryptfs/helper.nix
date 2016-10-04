{ stdenv
, fetchurl
, makeWrapper
, python
}:

stdenv.mkDerivation rec {
  name    = pname + "-" + version;
  pname   = "ecryptfs-helper";
  version = "20160722";

  src = fetchurl {
    url    = "https://gist.githubusercontent.com/obadz/ec053fdb00dcb48441d8313169874e30/raw/4b657a4b7c3dc684e4d5e3ffaf46ced1b7675163/ecryptfs-helper.py";
    sha256 = "0gp4m22zc80814ng80s38hp930aa8r4zqihr7jr23m0m2iq4pdpg";
  };

  phases = [ "installPhase" ];

  buildInputs = [ makeWrapper ];

  # Do not hardcode PATH to ${ecryptfs} as we need the script to invoke executables from /var/setuid-wrappers
  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp $src $out/libexec/ecryptfs-helper.py
    makeWrapper "${python.interpreter} $out/libexec/ecryptfs-helper.py" $out/bin/ecryptfs-helper
  '';

  meta = with stdenv.lib; {
    description    = "Helper script to create/mount/unemount encrypted directories using eCryptfs without needing root permissions";
    license        = licenses.gpl2Plus;
    maintainers    = with maintainers; [ obadz ];
    platforms      = platforms.linux;
    hydraPlatforms = [];
  };
}
