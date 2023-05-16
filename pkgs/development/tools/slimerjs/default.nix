<<<<<<< HEAD
{ lib
, bash
, fetchFromGitHub
, firefox
, strip-nondeterminism
, stdenv
, unzip
, zip
}:
=======
{ lib, stdenv, fetchFromGitHub, zip, unzip, firefox, bash }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "slimerjs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "laurentj";
    repo = "slimerjs";
    sha256 = "sha256-RHd9PqcSkO9FYi5x+09TN7c4fKGf5pCPXjoCUXZ2mvA=";
    rev = version;
  };

  buildInputs = [ zip ];
<<<<<<< HEAD
  nativeBuildInputs = [
    strip-nondeterminism
    unzip
  ];
=======
  nativeBuildInputs = [ unzip ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preConfigure = ''
    test -d src && cd src
    test -f omni.ja || zip omni.ja -r */
  '';

  installPhase = ''
<<<<<<< HEAD
    strip-nondeterminism --type zip omni.ja
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mkdir -p "$out"/{bin,share/doc/slimerjs,lib/slimerjs}
    cp LICENSE README* "$out/share/doc/slimerjs"
    cp -r * "$out/lib/slimerjs"
    echo '#!${bash}/bin/bash' >>  "$out/bin/slimerjs"
    echo 'export SLIMERJSLAUNCHER=${firefox}/bin/firefox' >>  "$out/bin/slimerjs"
    echo "'$out/lib/slimerjs/slimerjs' \"\$@\"" >> "$out/bin/slimerjs"
    chmod a+x "$out/bin/slimerjs"
    sed -e 's@MaxVersion=[3456][0-9][.]@MaxVersion=99.@' -i "$out/lib/slimerjs/application.ini"
  '';

  meta = with lib; {
    description = "Gecko-based programmatically-driven browser";
    license = licenses.mpl20;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
