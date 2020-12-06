{ stdenv, fetchFromGitHub, bash, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "rbenv";
  version = "1.1.2";

  nativeBuildInputs = [ installShellFiles ];

  src = fetchFromGitHub {
    owner = "rbenv";
    repo = "rbenv";
    rev = "v${version}";
    sha256 = "12i050vs35iiblxga43zrj7xwbaisv3mq55y9ikagkr8pj1vmq53";
  };

  postPatch = ''
     patchShebangs src/configure
     pushd src
  '';

  installPhase = ''
    popd
    mkdir -p $out/bin
    mv libexec $out
    ln -s $out/libexec/rbenv $out/bin/rbenv

    installShellCompletion completions/rbenv.{bash,zsh}
  '';

  meta = with stdenv.lib; {
    description = "Groom your app’s Ruby environment";
    longDescription = ''
      Use rbenv to pick a Ruby version for your application and guarantee that your development environment matches production.
      Put rbenv to work with Bundler for painless Ruby upgrades and bulletproof deployments.
    '';
    homepage = "https://github.com/rbenv/rbenv";
    license = licenses.mit;
    maintainers = with maintainers; [ fzakaria ];
    platforms = platforms.all;
  };
}
