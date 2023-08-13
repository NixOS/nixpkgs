{ lib
, buildGoModule
, fetchFromGitHub
, git
}:
buildGoModule {
  pname = "zoekt";
  version = "unstable-2022-11-09";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "zoekt";
    rev = "c4b18d3b44da94b3e7c9c94467d68c029666bb86";
    hash = "sha256-QtwOiBxBeFkhRfH3R2fP72b05Hc4+zt9njqCNVcprZ4=";
  };

  vendorHash = "sha256-DiAqFJ8E5V0/eHztm92WVrf1XGPXmmOaVXaWHfQMn2k=";

  nativeCheckInputs = [
    git
  ];

  preCheck = ''
    export HOME=`mktemp -d`
    git config --global --replace-all protocol.file.allow always
  '';

  meta = with lib; {
    description = "Fast trigram based code search";
    homepage = "https://github.com/google/zoekt";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
