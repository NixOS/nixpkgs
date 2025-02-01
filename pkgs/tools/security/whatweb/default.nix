{ lib, stdenv, fetchFromGitHub, bundlerEnv, ruby }:

let
  gems = bundlerEnv {
    name = "whatweb-env";
    inherit ruby;
    gemdir = ./.;
  };

in stdenv.mkDerivation rec {
  pname = "whatweb";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "urbanadventurer";
    repo = "whatweb";
    rev = "v${version}";
    sha256 = "sha256-HLF55x4C8n8aPO4SI0d6Z9wZe80krtUaGUFmMaYRBIE=";
  };

  prePatch = ''
    substituteInPlace Makefile \
      --replace "/usr/local" "$out" \
      --replace "/usr" "$out"
  '';

  buildInputs = [ gems ];

  installPhase = ''
    runHook preInstall

    raw=$out/share/whatweb/whatweb
    rm $out/bin/whatweb
    cat << EOF >> $out/bin/whatweb
    #!/bin/sh -e
    exec ${gems}/bin/bundle exec ${ruby}/bin/ruby "$raw" "\$@"
    EOF
    chmod +x $out/bin/whatweb

    runHook postInstall
  '';

  meta = with lib; {
    description = "Next generation web scanner";
    mainProgram = "whatweb";
    homepage = "https://github.com/urbanadventurer/whatweb";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = platforms.unix;
  };
}
