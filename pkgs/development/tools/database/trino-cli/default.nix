{ lib, stdenv, fetchurl, jre_headless, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "trino-cli";
<<<<<<< HEAD
  version = "422";
=======
  version = "416";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  jarfilename = "${pname}-${version}-executable.jar";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchurl {
    url = "mirror://maven/io/trino/${pname}/${version}/${jarfilename}";
<<<<<<< HEAD
    sha256 = "sha256-isOcZDbm4Ykkolmcn4lRMkknZkTYRvMOXVZlGKRnXU8=";
=======
    sha256 = "sha256-0jIOGFPlWgF/vaXTff0hiOWDA7ayiMmzo54eUZp4rsU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D "$src" "$out/share/java/${jarfilename}"

    makeWrapper ${jre_headless}/bin/java $out/bin/trino \
      --add-flags "-jar $out/share/java/${jarfilename}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "The Trino CLI provides a terminal-based, interactive shell for running queries";
    homepage = "https://github.com/trinodb/trino";
    license = licenses.asl20;
    maintainers = with maintainers; [ regadas cpcloud ];
  };
}
