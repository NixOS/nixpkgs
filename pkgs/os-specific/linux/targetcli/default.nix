{ lib, python3, fetchFromGitHub, nixosTests }:

python3.pkgs.buildPythonApplication rec {
  pname = "targetcli";
  version = "2.1.57";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    rev = "v${version}";
    hash = "sha256-7JRNHKku9zTeSafL327hkM/E5EWTKqwPudCfmngvWuo=";
  };

  propagatedBuildInputs = with python3.pkgs; [ configshell rtslib ];

  postInstall = ''
    install -D targetcli.8 -t $out/share/man/man8/
    install -D targetclid.8 -t $out/share/man/man8/
  '';

  passthru.tests = {
    inherit (nixosTests) iscsi-root;
  };

  meta = with lib; {
    description = "A command shell for managing the Linux LIO kernel target";
    homepage = "https://github.com/open-iscsi/targetcli-fb";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
