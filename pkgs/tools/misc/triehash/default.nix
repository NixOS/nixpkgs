{ lib
, stdenv
, fetchFromGitHub
, perlPackages
}:

stdenv.mkDerivation rec {
  pname = "triehash";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "julian-klode";
    repo = pname;
    rev = "debian/0.3-3";
    hash = "sha256-LxVcYj2WKHbhNu5x/DFkxQPOYrVkNvwiE/qcODq52Lc=";
  };

  nativeBuildInputs = [
    perlPackages.perl
  ];

  postPatch = ''
    patchShebangs triehash.pl
  '';

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -d $out/bin $out/share/doc/${pname}/ $out/share/${pname}/
    install triehash.pl $out/bin/triehash
    install README.md $out/share/doc/${pname}/
    cp -r tests/ $out/share/${pname}/tests/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/julian-klode/triehash";
    description = "Order-preserving minimal perfect hash function generator";
    license = with licenses; mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = perlPackages.perl.meta.platforms;
    mainProgram = "triehash";
  };
}
