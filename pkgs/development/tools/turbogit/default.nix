{ fetchFromGitHub, buildGoModule, lib, installShellFiles, libgit2, pkg-config }:
buildGoModule rec {
  pname = "turbogit";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "b4nst";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BHgVJlitRUX/9zYPoK5XfRpzzTZRbLhQVZJcx8KVshk=";
  };

  vendorHash = "sha256-280OcGXZQJD4G6z0b2WnWAS+v7XVptyf2WnlPjG99/0=";

  subPackages = [ "." ];

  buildInputs = [ libgit2 ];
  nativeBuildInputs = [ installShellFiles pkg-config ];
  postInstall = ''
    # Move turbogit binary to tug
    ln -s $out/bin/turbogit $out/bin/tug

    # Generate completion files
    mkdir -p share/completions
    $out/bin/tug completion bash > share/completions/tug.bash
    $out/bin/tug completion fish > share/completions/tug.fish
    $out/bin/tug completion zsh > share/completions/tug.zsh

    installShellCompletion share/completions/tug.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "Keep your git workflow clean without headache";
    longDescription = ''
      turbogit (tug) is a cli tool built to help you deal with your day-to-day git work.
      turbogit enforces convention (e.g. The Conventional Commits) but tries to keep things simple and invisible for you.
      turbogit is your friend.
    '';
    homepage = "https://b4nst.github.io/turbogit";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.yusdacra ];
  };
}
