{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "jump";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "gsamokovarov";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pp3d9xkdaqrcbzwnnask8786capdxvgq6wbpwkzkfni978vv2l4";
  };

  modSha256 = "1fzsm85c31vkdw80kijxmjhk8jyhjz8b21npgks2qrnizhm6iaf8";

  outputs = [ "out" "man"];
  postInstall = ''
    install -D --mode=444 man/j.1 man/jump.1 -t $man/man/man1/

    # generate completion scripts for jump
    export HOME="$NIX_BUILD_TOP"
    mkdir -p $out/share/{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}
    $out/bin/jump shell bash > "$out/share/bash-completion/completions/jump"
    $out/bin/jump shell fish > $out/share/fish/vendor_completions.d/jump.fish
    $out/bin/jump shell zsh > $out/share/zsh/site-functions/_jump
  '';

  meta = with lib; {
    description = "Jump helps you navigate faster by learning your habits.";
    longDescription = ''
      Jump integrates with the shell and learns about your
      navigational habits by keeping track of the directories you visit. It
      strives to give you the best directory for the shortest search term.
    '';
    homepage = https://github.com/gsamokovarov/jump;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ sondr3 ];
  };
}
