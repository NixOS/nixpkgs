{
  lib,
  bundlerEnv,
  bundlerUpdateScript,
  git,
}:
bundlerEnv {
  pname = "homesick";

  gemdir = ./.;

  # Cannot use `wrapProgram` because the the help is aware of the file name.
  postInstall = ''
    rm $out/bin/thor
    sed 1a'ENV["PATH"] = "${git}/bin:#{ENV["PATH"] ? ":#{ENV["PATH"]}" : "" }"' -i $out/bin/homesick
  '';

  passthru.updateScript = bundlerUpdateScript "homesick";

  meta = with lib; {
    description = "Your home directory is your castle. Don't leave your dotfiles behind";
    longDescription = ''
      Homesick is sorta like rip, but for dotfiles. It uses git to clone a repository containing
      dotfiles, and saves them in ~/.homesick. It then allows you to symlink all the dotfiles into
      place with a single command.
    '';
    homepage = "https://github.com/technicalpickles/homesick";
    license = licenses.mit;
    maintainers = with maintainers; [
      aaronschif
      nicknovitski
    ];
    platforms = platforms.unix;
    mainProgram = "homesick";
  };
}
