{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "djenrandom";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "dj-on-github";
    repo = "djenrandom";
    rev = "${version}";
    hash = "sha256-r5UT8z8vvFZDffsl6CqBXuvBaZ/sl1WLxJi26CxkpAw=";
  };

  preBuild = ''
    sed -i s/gcc/${stdenv.cc.targetPrefix}gcc/g Makefile
  ''
  + lib.optionalString (!stdenv.hostPlatform.isx86_64) ''
    sed -i s/-m64//g Makefile
  '';

  installPhase = ''
    runHook preInstall
    install -D djenrandom $out/bin/djenrandom
    runHook postInstall
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = {
    homepage = "http://www.deadhat.com/";
    description = ''
      A C program to generate random data using several random models,
      with parameterized non uniformities and flexible output formats
    '';
    license = lib.licenses.gpl2Only;
    # djenrandom uses x86 specific instructions, therefore we can only compile for the x86 architechture
    platforms = lib.platforms.x86;
    maintainers = with lib.maintainers; [ orichter thillux ];
  };
}
