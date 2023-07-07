{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gobuster";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "OJ";
    repo = "gobuster";
    rev = "v${version}";
    hash = "sha256-Ohv/FgMbniItbrcrncAe9QKVjrhxoZ80BGYJmJtJpPk=";
  };

  vendorHash = "sha256-ZbY5PyXKcTB9spVGfW2Qhj8SV9alOSH0DyXx1dh/NgQ=";

  meta = with lib; {
    description = "Tool used to brute-force URIs, DNS subdomains, Virtual Host names on target web servers";
    homepage = "https://github.com/OJ/gobuster";
    changelog = "https://github.com/OJ/gobuster/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
