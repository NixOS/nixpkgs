{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, bc
, ncurses
, testers
, fzf
}:

buildGoModule rec {
  pname = "fzf";
  version = "0.49.0";

  src = fetchFromGitHub {
    owner = "junegunn";
    repo = pname;
    rev = version;
    hash = "sha256-XecMHKi5JMWx3RHQRk2FqS3SjyR6KzWjfyQ5JCI45xM=";
  };

  vendorHash = "sha256-ZEwB2GKohmOx8xosj14VII6sQ4a82s7+h9r620MKEeU=";

  CGO_ENABLED = 0;

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ ncurses ];

  ldflags = [
    "-s" "-w" "-X main.version=${version} -X main.revision=${src.rev}"
  ];

  # The vim plugin expects a relative path to the binary; patch it to abspath.
  postPatch = ''
    sed -i -e "s|expand('<sfile>:h:h')|'$out'|" plugin/fzf.vim

    if ! grep -q $out plugin/fzf.vim; then
        echo "Failed to replace vim base_dir path with $out"
        exit 1
    fi

    # fzf-tmux depends on bc
    substituteInPlace bin/fzf-tmux \
      --replace "bc" "${bc}/bin/bc"
  '';

  postInstall = ''
    install bin/fzf-tmux $out/bin

    installManPage man/man1/fzf.1 man/man1/fzf-tmux.1

    install -D plugin/* -t $out/share/vim-plugins/${pname}/plugin
    mkdir -p $out/share/nvim
    ln -s $out/share/vim-plugins/${pname} $out/share/nvim/site
  '';

  passthru.tests.version = testers.testVersion {
    package = fzf;
  };

  meta = with lib; {
    homepage = "https://github.com/junegunn/fzf";
    description = "A command-line fuzzy finder written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ma27 zowoq ];
    platforms = platforms.unix;
    changelog = "https://github.com/junegunn/fzf/blob/${version}/CHANGELOG.md";
    mainProgram = "fzf";
  };
}
