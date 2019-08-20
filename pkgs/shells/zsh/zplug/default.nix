{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2.4.2";
  pname = "zplug";

  src = fetchFromGitHub {
    owner = "zplug";
    repo = "zplug";
    rev = version;
    sha256 = "0hci1pbs3k5icwfyfw5pzcgigbh9vavprxxvakg1xm19n8zb61b3";
  };

  configurePhase = ''

  '';

  buildPhase = ''

  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r $src $out/opt/zplug

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A next-generation plugin manager for zsh";
    longDescription = ''
      ZPlug is a next-generation plugin manager for zsh.

      To use zplug, add the following to your .zshrc:

        export ZPLUG_HOME=$HOME/.zplug
        source $(nix-env -q --out-path zplug | cut -d ' ' -f 3)/opt/zplug/init.zsh
    '';
    homepage = "https://zplug.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ kayhide ];
  };
}
