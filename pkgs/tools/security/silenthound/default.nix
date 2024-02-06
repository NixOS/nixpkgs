{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "silenthound";
  version = "unstable-2022-09-02";
  format = "other";

  src = fetchFromGitHub {
    owner = "layer8secure";
    repo = "SilentHound";
    rev = "44d361f6c95b79bd848603c8050af86db3d072b0";
    hash = "sha256-6JcU6FIE+9fsMawI1RSNQyx9ubjxmchEKmeg6/kmI4s=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    colorama
    python-ldap
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -vD $pname.py $out/bin/$pname

    runHook postInstall
  '';

  # Only script available
  doCheck = false;

  meta = with lib; {
    description = "Tool to enumerate an Active Directory Domain";
    homepage = "https://github.com/layer8secure/SilentHound";
    # Unknown license, https://github.com/layer8secure/SilentHound/issues/1
    license = licenses.unfree;
    maintainers = with maintainers; [ fab ];
    mainProgram = "silenthound";
  };
}
