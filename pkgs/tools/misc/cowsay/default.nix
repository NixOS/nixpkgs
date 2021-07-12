{ lib, stdenv, perl, installShellFiles, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "cowsay";
  version = "3.04";

  src = fetchFromGitHub {
    owner = "tnalpgge";
    repo = "rank-amateur-cowsay";
    rev = "cowsay-${version}";
    sha256 = "sha256-9jCaQ6Um6Nl9j0/urrMCRcsGeubRN3VWD3jDM/AshRg=";
  };

  buildInputs = [ perl ];

  nativeBuildInputs = [ installShellFiles ];

  # overriding buildPhase because we don't want to use the install.sh script
  buildPhase = ''
    runHook preBuild;
    substituteInPlace cowsay --replace "%BANGPERL%" "!${perl}/bin/perl" \
      --replace "%PREFIX%" "$out"
    runHook postBuild;
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 cowsay $out/bin/cowsay
    ln -s $out/bin/cowsay $out/bin/cowthink

    installManPage cowsay.1
    ln -s $man/share/man/man1/cowsay.1.gz $man/share/man/man1/cowthink.1.gz

    install -Dm644 cows/* -t $out/share/cows/
    runHook postInstall
  '';

  outputs = [ "out" "man" ];

  meta = with lib; {
    description = "A program which generates ASCII pictures of a cow with a message";
    homepage = "https://github.com/tnalpgge/rank-amateur-cowsay";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.rob ];
  };
}
