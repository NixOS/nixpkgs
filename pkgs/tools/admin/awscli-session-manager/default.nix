{ stdenv, fetchzip, unzip, python3 }:

stdenv.mkDerivation rec {
  pname = "awscli-session-manager";
  version = "1.1.54.0";

  phases = [ "unpackPhase" "installPhase" ];

  base_url = "https://s3.amazonaws.com/session-manager-downloads/plugin";
  docs_url = "https://docs.aws.amazon.com/systems-manager/${version}/userguide/";

  src =
    fetchzip rec {
      name = "sessionmanager-bundle.zip";
      url = "${base_url}/${version}/mac/${name}";
      sha256 = "0q5wh8f0m282mdclnzppgh2f4zvswq89i52zpdi06qmi2byc33cf";
    };

  buildInputs = [ python3 ];

  installPhase = ''
    ./install -i $out -b $out/bin/${pname}
    addToSearchPath _PATH $out/bin
  '';

  meta = with stdenv.lib; {
    description = "AWS Systems Manager Session Manager";
    longDescription = ''
      Session Manager is a fully managed AWS Systems Manager capability that
      lets you manage your Amazon EC2 instances, on-premises instances,
      and virtual machines (VMs).
    '';
    homepage = "${docs_url}/session-manager.html";
    changelog = "${docs_url}/session-manager-working-with-install-plugin.html#plugin-version-history";
    license = licenses.bsd3;
    platforms = platforms.darwin;
  };
}
