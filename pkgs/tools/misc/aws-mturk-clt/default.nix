{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "aws-mturk-clt-1.3.0";
  
  src = fetchurl {
    url = "http://mturk.s3.amazonaws.com/CLTSource/${name}.tar.gz";
    sha256 = "06p0cbb5afmqjjlibbw9gb08jp270c7j57lhnf9ld50sm1z021ln";
  };

  installPhase =
    ''
      mkdir -p $out
      cp -prvd bin $out/

      for i in $out/bin/*.sh; do
        sed -i "$i" -e "s|^MTURK_CMD_HOME=.*|MTURK_CMD_HOME=$out\nexport JAVA_HOME=${jre}|"
      done

      mkdir -p $out/lib
      cp -prvd lib/* $out/lib/
    ''; # */

  meta = {
    homepage = https://requester.mturk.com/developer;
    description = "Command line tools for interacting with the Amazon Mechanical Turk";
    license = "unfree-redistributable"; # Amazon http://aws.amazon.com/asl/

    longDescription =
      ''
        The Amazon Mechanical Turk is a crowdsourcing marketplace that
        allows users (“requesters”) to submit tasks to be performed by
        other humans (“workers”) for a small fee.  This package
        contains command-line tools for submitting tasks, querying
        results, and so on.

        The command-line tools expect a file
        <filename>mturk.properties<filename> in the current directory,
        which should contain the following:

        <screen>
        access_key=[insert your access key here]
        secret_key=[insert your secret key here]
        service_url=http://mechanicalturk.amazonaws.com/?Service=AWSMechanicalTurkRequester
        </screen>
      '';
  };
}
