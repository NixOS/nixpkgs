{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gow";
  version = "unstable-2023-04-18";

  src = fetchFromGitHub {
    owner = "mitranim";
    repo = "gow";
    rev = "87df6e48eec654d4e4dfa9ae4c9cdb378cb3796b";
    hash = "sha256-hXjVQXt7sp7zVQf2gv6tc+P17tM3hp3CKees6EjnqP4=";
  };

  vendorHash = "sha256-Q5Z/hVY/gpWv4v2f73xNAI1t7ZXsuIVuVW9FapXmETM=";

  ldflags = [ "-s" "-w" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/gow -h
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Missing watch mode for Go commands. Watch Go files and execute a command like \"go run\" or \"go test\"";
    longDescription = ''
      Go Watch: missing watch mode for the go command. It's invoked exactly
      like go, but also watches Go files and reruns on changes.
    '';
    homepage = "https://github.com/mitranim/gow";
    license = licenses.unlicense;
    maintainers = with maintainers; [ jk ];
    platforms = platforms.unix;
  };
}
