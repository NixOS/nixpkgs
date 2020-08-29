{ stdenv, lib
, fetchurl, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "concourse-bin";
  version = "6.5.1";

  src = fetchurl {
    url = "https://github.com/concourse/concourse/releases/download/v${version}/concourse-${version}-linux-amd64.tgz";
    sha256 = "ec0ed4a68a7221edea8ded0f569655298419ef4de8f9193b59dcd5098a4a360c";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase = ''
    install -m755 -D bin/concourse $out/bin/concourse
  '';

  meta = with lib; {
    description = "Concourse is a pipeline-based continuous thing-doer.";
    homepage = "https://concourse-ci.org/docs.html";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ fooker ];
  };
}
