{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage {
  pname = "lmt";
  version = "unstable-2021-04-21";

  goPackagePath = "main";

  src = fetchFromGitHub {
    owner = "driusan";
    repo = "lmt";
    rev = "a940ba5299babf61ab6dfc72f308ea362cb6e4ec";
    sha256 = "0jpiv9xm8wbi8rdfkkqfhqmjqqfzzhbwwh9m2n52cy4dxbfs8wbh";
  };

  postInstall = ''
    mv $out/bin/main $out/bin/lmt
  '';

  meta = with lib; {
    homepage = "https://github.com/driusan/lmt";
    description = "A literate programming tool for Markdown";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ nat-418 ];
  };
}
