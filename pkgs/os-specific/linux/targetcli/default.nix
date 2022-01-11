{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "targetcli";
  version = "2.1.54";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    rev = "v${version}";
    sha256 = "1kbbvx0lba96ynr5iwws9jpi319m4rzph4bmcj7yfb37k8mi161v";
  };

  propagatedBuildInputs = with python3.pkgs; [ configshell rtslib ];

  postInstall = ''
    install -D targetcli.8 -t $out/share/man/man8/
    install -D targetclid.8 -t $out/share/man/man8/
  '';

  meta = with lib; {
    description = "A command shell for managing the Linux LIO kernel target";
    homepage = "https://github.com/open-iscsi/targetcli-fb";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
