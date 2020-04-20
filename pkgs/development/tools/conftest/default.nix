{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "conftest";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "instrumenta";
    repo = "conftest";
    rev = "v${version}";
    sha256 = "0ial1zs5aqcwza813ny6zqn9ybq6ibrqjmaccwbbam1k9f5rplqv";
  };

  modSha256 = "17j5fhgwfpyg9r7a5g9rmvkaz510xx9s4mbl1cmyzysvddc6f5wp";

  buildFlagsArray = ''
    -ldflags=
        -X main.version=${version}
  '';

  meta = with lib; {
    description = "Write tests against structured configuration data";
    homepage = "https://github.com/instrumenta/conftest";
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
    platforms = platforms.all;
  };
}
