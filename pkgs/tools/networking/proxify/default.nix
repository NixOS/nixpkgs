{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "proxify";
<<<<<<< HEAD
  version = "0.0.12";
=======
  version = "0.0.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "proxify";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-j2FuyoTCc9mcoI683xZkMCL6QXy0dGEheNaormlgUvY=";
  };

  vendorHash = "sha256-kPj3KBi8Mbsj4BW7Vf1w4mW8EN07FuqgFhAkkLCl8Bc=";
=======
    hash = "sha256-InHo5nfgCLDxciwjaB9tamV6MGEM3DlRGU00Ng2SfVY=";
  };

  vendorHash = "sha256-GPkxUU9HXLWnj+qjee/CuSE683l2V22cH9KBP2ssaXc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Proxy tool for HTTP/HTTPS traffic capture";
    longDescription = ''
      This tool supports multiple operations such as request/response dump, filtering
      and manipulation via DSL language, upstream HTTP/Socks5 proxy. Additionally a
      replay utility allows to import the dumped traffic (request/responses with correct
      domain name) into other tools by simply setting the upstream proxy to proxify.
    '';
    homepage = "https://github.com/projectdiscovery/proxify";
    changelog = "https://github.com/projectdiscovery/proxify/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
