{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
    sha256 = "01rw7gdvpr2s3yj7wphsm5gfrgzf5jkrci4mpqiw7xp8d5k87nzl";
  };

  preInstall = ''
    install -Dm644 -t $out/share/mcfly mcfly.bash
    install -Dm644 -t $out/share/mcfly mcfly.zsh
  '';

  cargoSha256 = "1q1mi69prn9q1nk4021c69vq160ls6md6gpqxk7zyf25r5ckdd98";

  meta = with stdenv.lib; {
    homepage = "https://github.com/cantino/mcfly";
    description = "An upgraded ctrl-r for Bash whose history results make sense for what you're working on right now";
    license = licenses.mit;
    maintainers = [ maintainers.melkor333 ];
  };
}
